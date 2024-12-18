defmodule Chat.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Chat.Repo
  alias ChatWeb.Endpoint

  alias Chat.Messages.Message

  @doc """
  Returns the list of message.

  ## Examples

      iex> list_message()
      [%Message{}, ...]

  """
  def list_message do
    Repo.all(Message)
  end

  def list_message(id) do
    Repo.all(
      from m in Message,
        where: m.room_id == ^id,
        order_by: [asc: m.inserted_at],
        preload: [:sender]
    )
  end

  def last_ten_messages(id) do
    Repo.all(
      from m in Message, where: m.room_id == ^id, order_by: [desc: m.inserted_at], limit: 10
    )
  end

  def preload_message_sender(message) do
    message
    |> Repo.preload(:sender)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  def last_user_message_for_room(room_id, current_user_id) do
    Repo.one(
      from m in Message,
        where: m.room_id == ^room_id and m.sender_id == ^current_user_id,
        order_by: [desc: m.inserted_at],
        limit: 1
    )
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        Endpoint.broadcast("room:#{message.room_id}", "new_message", %{message: message})

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, message} ->
        Endpoint.broadcast("room:#{message.room_id}", "updated_message", %{message: message})
    end
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
    |> case do
      {:ok, message} ->
        Endpoint.broadcast("room:#{message.room_id}", "deleted_message", %{message: message.id})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
