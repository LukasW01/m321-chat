defmodule ChatWeb.ChatLive.Message.Form do
  @moduledoc """
  The form component to create a new message.
  """
  use ChatWeb, :live_component
  import ChatWeb.CoreComponents
  alias Chat.Messages

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form :let={f} for={@form} phx-submit="save" phx-change="update" phx-target={@myself}>
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
  Initialize the changeset with an empty message content
  """
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, Messages.change_message(%Messages.Message{}))}
  end

  @doc """
  Check the content of the input field and update the changeset
    
  Info: This will be called when the user types in the input field
  """
  def handle_event("update", %{"content" => content}, socket) do
    {:noreply,
     socket
     |> assign(:form, Messages.change_message(%Messages.Message{content: content}))}
  end

  @doc """
  Create a new message and assign an empty changeset (clear the form)
    
  Hint: The create_message function will broadcast the new message to the room:id channel
  """
  def handle_event("save", %{"content" => content}, socket) do
    case Messages.create_message(%{
           content: content,
           room_id: socket.assigns.room_id,
           sender_id: socket.assigns.sender_id
         }) do
      :ok ->
        {:noreply,
         socket
         |> assign(:form, Messages.change_message(%Messages.Message{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
