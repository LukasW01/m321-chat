defmodule Chat.UserIdentities.UserIdentity do
  @moduledoc """
  The schema for the user identities.
  """
  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Chat.Users.User

  schema "user_identities" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
