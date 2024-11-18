defmodule ChatWeb.ChatLive.Message.EditForm do
  use ChatWeb, :live_component
  alias Chat.Messages

  def render(assigns) do
    ~H"""
    <div>
      <.modal id="edit_message">
        <.simple_form
          :let={f}
          for={@form}
          phx-submit={JS.push("update") |> hide_modal("edit_message")}
          phx-target={@myself}
        >
          <.input autocomplete="off" field={f[:content]} type="text" phx-debounce="500" />
          <:actions>
            <.button>send</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  @doc """
  Initialize the changeset with the message content
  """
  def update(%{message: message} = assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_new(:form, fn ->
        to_form(Messages.change_message(message))
      end)}
  end

  @doc """
  Update the message content and hide the modal
  """
  def handle_event("update",  %{"content" => content}, socket) do
    Messages.update_message(socket.assigns.message, %{content: content})

    {:noreply, socket}
  end
end