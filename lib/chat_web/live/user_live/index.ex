defmodule ChatWeb.UserLive.Index do
  use ChatWeb, :live_view

  alias Chat.Users
  alias Chat.Users.User
  alias ChatWeb.Endpoint

  @doc """
  Mount the live view
    
  If the user is not authorized, redirect to the login page.

  Returns either:
    {:error} -> Unauthorized access or DB error
    {:ok} -> [User{}]
  """
  @impl true
  def mount(_params, _session, socket) do
    case Users.list_user(socket.assigns.current_user) do
      {:ok, users} ->
        {:ok,
         socket
         |> stream(:user_collection, users)}

      {:error, _} ->
        {:ok,
         socket
         |> put_flash(:error, gettext("Unauthorized access"))
         |> push_redirect(to: "/")}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "User")
    |> assign(:user, nil)
  end

  @doc """
  Handle the event when a user is banned and stream_delete the user on the client
  """
  @impl true
  def handle_event("ban", %{"id" => id}, socket) do
    case Users.ban(id, socket.assigns.current_user, %{ban: true}) do
      :ok ->
        {:noreply,
         socket
         |> stream_delete(:user_collection, %{id: id})
         |> put_flash(:info, "User has been banned")}

      :error ->
        {:noreply, put_flash(socket, :error, "Failed to ban user")}
    end
  end
end
