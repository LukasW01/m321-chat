ExUnit.configure(formatters: [JUnitFormatter])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(chat.Repo, :manual)
