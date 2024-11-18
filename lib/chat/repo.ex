defmodule Chat.Repo do
  use Ecto.Repo,
    otp_app: :chat,
    adapter: if(Mix.env() == :test, do: Ecto.Adapters.SQLite3, else: Ecto.Adapters.Postgres)
end
