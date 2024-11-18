defmodule ChatWeb.ChatLive.Message.Form do
  use ChatWeb, :live_component
  import ChatWeb.CoreComponents
  alias Chat.Messages
  
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={@changeset}
        phx-submit="save"
        phx-change="update"
        phx-target={@myself}
      >
        <.input
          autocomplete="off"
          phx-keydown={show_modal("edit_message")}
          phx-key="ArrowUp"
          field={{f, :content}}
          type="text"
          name="content"
          value=""
        />
        <:actions>
          <.button>send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @doc """
  Initialize the changeset with the message content
  """
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Messages.change_message(%Messages.Message{}))}
  end

  @doc """
  Check if the message content is updated and assign the changeset
  """
  def handle_event("update", %{"content" => content}, socket) do
    {:noreply,
      socket
      |> assign(:changeset, Messages.change_message(%Messages.Message{content: content}))}
  end

  @doc """
  Create a new message and assign an empty changeset (clear the form)
  """
  def handle_event("save", %{"content" => content}, socket) do
    Messages.create_message(%{content: content, room_id: socket.assigns.room_id, sender_id: socket.assigns.sender_id})

    {:noreply, 
      socket
      |> assign(:changeset, Messages.change_message(%Messages.Message{}))}
  end
end
