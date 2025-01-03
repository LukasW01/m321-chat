defmodule ChatWeb.ChatLive.Root do
  use ChatWeb, :live_view
  alias Chat.Messages
  alias Chat.Rooms
  alias Chat.Users
  alias ChatWeb.Endpoint
  alias Chat.Util.User

  @doc """
  Mount the live view and assign the rooms and the current user
  """
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:rooms, Rooms.list_rooms())
     |> assign(:room, nil)
     |> assign(:message, %Messages.Message{})
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:action, :index)}
  end

  @doc """
  @route: "/rooms/:id"
  Handle the param (:id) and subscribe to the room channel if the user is not yet connected. 

  If the user is banned, redirect to the rooms page with a flash message.

  Info: The last_user_message is used for the message edit form to show the last message sent by the current user.
  """
  def handle_params(%{"id" => id}, _uri, %{assigns: %{live_action: :show}} = socket) do
    if User.ban?(socket.assigns.current_user.id) do
      {:noreply,
       socket
       |> put_flash(:error, "You have been banned")
       |> push_navigate(to: "/rooms")}
    else
      if connected?(socket) do
        # Used to broadcast messages to the room channel
        Endpoint.subscribe("room:#{id}")
        # Any user specific events
        Endpoint.subscribe("user:#{socket.assigns.current_user.id}")
      end

      {:noreply,
       socket
       |> assign(:room, Rooms.get_room!(id))
       |> stream(:messages, Messages.list_message(id))
       |> last_user_message()
       |> assign(:current_user, socket.assigns.current_user)}
    end
  end

  @doc """
  Default handle_params/3 implementation for when the user is not in a room.
  """
  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @doc """
  Handle the event when a new message is sent and stream_insert the message on the client
  """
  def handle_info(%{event: "new_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> stream_insert(:messages, Messages.preload_message_sender(message))
     |> last_user_message()}
  end

  @doc """
  Handle the event when a message is updated by the edit_form and stream_update the message on the client
  """
  def handle_info(%{event: "updated_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> stream_insert(:messages, Messages.preload_message_sender(message), at: -1)
     |> last_user_message(message)}
  end

  def handle_info(%{event: "deleted_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> stream_delete(:messages, %{id: message})
     |> last_user_message()}
  end

  @doc """
  Handle the event when a user is banned and redirect to the rooms page with a flash message
  """
  def handle_info(%{event: "ban", payload: %{}}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "You have been banned")
     |> push_navigate(to: "/rooms")}
  end

  @doc """
  Handle the event when a message is deleted and stream_delete the message on the client
  """
  def handle_event("delete_message", %{"item_id" => message_id}, socket) do
    message = Messages.get_message!(message_id)
    Messages.delete_message(message)

    {:noreply, stream_delete(socket, :messages, message)}
  end

  @doc """
  If the user is not authorized, close the modal

  Returns either:
    {:error} -> Unauthorized access or DB error
    {:ok} -> [User{}]
  """
  def handle_event("ban", _params, socket) do
    case Users.list_user(socket.assigns.current_user) do
      {:ok, users} ->
        {:noreply,
         socket
         |> assign(:action, :ban)
         |> stream(:user_collection, users)}

      {:error, _error} ->
        {:ok,
         socket
         |> assign(:action, :index)}
    end
  end

  @doc """
  Handle the event when a user is banned and stream_delete the user on the client
  """
  @impl true
  def handle_event("ban_user", %{"id" => id}, socket) do
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

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :action, :index)}
  end

  @doc """
  Assign the last message sent by the current user
  """
  def last_user_message(%{assigns: %{current_user: current_user}} = socket, message)
      when current_user.id == message.sender_id do
    assign(socket, :message, message)
  end

  @doc """
  Assign the last message sent by the current user in case the message is not the last one
  """
  def last_user_message(%{assigns: %{room: room, current_user: current_user}} = socket) do
    assign(
      socket,
      :message,
      Messages.last_user_message_for_room(room.id, current_user.id) || %Messages.Message{}
    )
  end
end
