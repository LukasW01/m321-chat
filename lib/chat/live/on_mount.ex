# Remove when upstream Pow can handle LiveView/socket auth
defmodule Chat.OnMount do
  @moduledoc """
  on_mount/4 actions when a LiveView is mounted:
  - Assigns @current_user to the socket for LiveView
  - Sets the locale (de, en)

  @link: https://github.com/pow-auth/pow/issues/706
  """
  use Phoenix.LiveView
  use ChatWeb, :verified_routes

  def on_mount(:default, _params, session, socket) do
    socket = mount_current_user(socket, session)

    if socket.assigns.current_user do
      mound_locale(socket.assigns.current_user.locale)

      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "Could not assign current user")
        |> Phoenix.LiveView.redirect(to: ~p"/session/new")

      {:halt, socket}
    end
  end

  defp mount_current_user(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      {_conn, user} =
        %Plug.Conn{
          private: %{
            plug_session_fetch: :done,
            plug_session: session,
            pow_config: [otp_app: :chat]
          },
          owner: self(),
          remote_ip: {0, 0, 0, 0}
        }
        |> Map.put(:secret_key_base, ChatWeb.Endpoint.config(:secret_key_base))
        |> Pow.Plug.Session.fetch(otp_app: :chat)

      user
    end)
  end

  defp mound_locale(locale) do
    Gettext.put_locale(ChatWeb.Gettext, locale || "de")
  end
end
