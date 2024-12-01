defmodule Chat.Users.User do
  @moduledoc """
  Module for user schema and authentication.
  """
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    pow_user_fields()
    field :role, :string, default: "user"
    field :locale, :string
    field :name, :string
    field :ban, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:ban])
    |> validate_required([:ban])
  end

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role, :locale, :name])
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
  end
end
