defmodule Chat.Auth.Policy.Checks do
  @moduledoc """
  Validates the User and Role
  """
  alias Chat.Users.User

  @doc """
  Checks whether the user ID of the struct matches the ID of the current user.
  case Tasks.list_task(socket.assigns.current_user) do
  {:ok, tasks} ->
    {:ok, stream(socket, :task_collection, tasks)}

  {:error, :unauthorized} ->
    {:error, :unauthorized} # You may want to handle this error differently, such as redirecting or showing a message
  end
  """
  def own_resource(%User{id: id}, %{user_id: id}, _opts) when is_binary(id), do: true
  def own_resource(_, _, _), do: false

  @doc """
  Checks whether the user role matches the role passed as an option.

  ## Usage

      allow role: :editor

  or

      allow {:role, :editor}
  """
  def role(%User{role: role}, _object, role), do: true
  def role(_, _, _), do: false
end
