defmodule Chat.Repo.Migrations.AddBanCollum do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :ban, :boolean, default: false
    end
  end
end
