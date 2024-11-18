defmodule Chat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :content, :string
      add :sender_id, references(:users, on_delete: :delete_all)
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:message, [:sender_id])
    create index(:message, [:room_id])
  end
end
