defmodule ChatWeb.ChatLive.Room do
  use Phoenix.Component
  alias ChatWeb.ChatLive.{Messages, Message}

  def show(assigns) do
    ~H"""
    <div id={"room-#{@room.id}"}>
      <Messages.list_messages messages={@messages} current_user={@current_user} />
      <.live_component
        module={Message.Form}
        room_id={@room.id}
        sender_id={@current_user.id}
        id={"room-#{@room.id}-message-form"}
      />
    </div>
    """
  end
end
