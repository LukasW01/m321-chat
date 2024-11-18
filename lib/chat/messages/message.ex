defmodule Chat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Users.User
  alias Chat.Rooms.Room

  schema "message" do
    field :content, :string
    belongs_to :room, Room
    belongs_to :sender, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :room_id, :sender_id])
    |> cast_assoc(:sender)
    |> cast_assoc(:room)
    |> validate_required([:content])
  end
end
