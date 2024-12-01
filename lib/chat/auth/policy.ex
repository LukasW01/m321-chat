defmodule Chat.Auth.Policy do
  @moduledoc """
  Authorization Policies (CRUD)

  @docs: https://hexdocs.pm/let_me/LetMe.Policy.html
  """
  use LetMe.Policy

  object :user do
    action [:delete, :update, :read, :create] do
      allow role: "admin"
      deny role: "user"
    end
  end
end
