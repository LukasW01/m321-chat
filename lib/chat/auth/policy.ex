defmodule Chat.Auth.Policy do
  @moduledoc """
  Authorization Policies (CRUD)

  @docs: https://hexdocs.pm/let_me/LetMe.Policy.html
  """
  use LetMe.Policy

  object :user do
    action [:create, :read, :update, :delete] do
      allow role: "admin"
      deny role: "user"
    end
  end

  object :room do
    action [:create, :read, :update, :delete] do
      allow role: "admin"
      allow role: "user"
    end
  end

  object :message do
    action [:create, :read, :update, :delete] do
      allow role: "admin"
      allow role: "user"
    end
  end
end
