defmodule Chat.Util.Ban do
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
  def is_banned?(id) do
    Users.get_user!(id)
    |> Map.get(:ban)
  end
end
