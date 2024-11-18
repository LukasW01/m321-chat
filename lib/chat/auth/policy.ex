defmodule Chat.Auth.Policy do
  @moduledoc """
  Authorization Policies (CRUD)

  @docs: https://hexdocs.pm/let_me/LetMe.Policy.html
  """
  use LetMe.Policy

  object :rooms do
    action [:create, :delete, :update] do
      allow role: "admin"
      allow role: "user"
    end

    action [:read] do
      allow role: "admin"
      allow role: "user"
    end
  end
end
