defmodule Chat.Util.User do
  @moduledoc """
  Util module for ban related functions.
  """

  alias Chat.Users

  @doc """
  Checks if a user is banned.

  ## Example

      iex> is_banned?(1)
      true
  """
  def ban?(id) do
    Users.get_user!(id)
    |> Map.get(:ban)
  end
end
