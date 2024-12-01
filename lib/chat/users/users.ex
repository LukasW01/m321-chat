defmodule Chat.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Chat.Repo

  alias Chat.Users.User
  alias Chat.Auth.Policy

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user(%User{} = current_user) do
    with :ok <- Policy.authorize(:user_read, current_user) do
      {:ok, Repo.all(from u in User, where: u.ban == false and u.role != "admin")}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id, %User{} = current_user) do
    with {:ok, user} <- Policy.authorize(:user_read, %User{}) do
      Repo.get!(User, id)
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Bans a user.
    
  ## Examples

      iex> ban(123, %{ban: true})
      :ok

      iex> ban(456, %{ban: false})
      :error

  """
  def ban(id, current_user, params) do
    case get_user!(id, current_user) do
      %User{} = user ->
        case update_user(user, params) do
          {:ok, _user} ->
            Endpoint.broadcast("user:#{id}", "ban", %{})

            :ok

          {:error, _changeset} ->
            :error
        end

      _ ->
        :error
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
