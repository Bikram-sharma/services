defmodule Services.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias Services.Repo

  alias Services.Notifications.SpecialNotification
  alias Services.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any special_notification changes.

  The broadcasted messages match the pattern:

    * {:created, %SpecialNotification{}}
    * {:updated, %SpecialNotification{}}
    * {:deleted, %SpecialNotification{}}

  """
  def subscribe_special_notifications(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Services.PubSub, "user:#{key}:special_notifications")
  end

  defp broadcast_special_notification(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Services.PubSub, "user:#{key}:special_notifications", message)
  end

  @doc """
  Returns the list of special_notifications.

  ## Examples

      iex> list_special_notifications(scope)
      [%SpecialNotification{}, ...]

  """
  def list_special_notifications(%Scope{} = scope) do
    Repo.all_by(SpecialNotification, user_id: scope.user.id)
  end

  @doc """
  Gets a single special_notification.

  Raises `Ecto.NoResultsError` if the Special notification does not exist.

  ## Examples

      iex> get_special_notification!(scope, 123)
      %SpecialNotification{}

      iex> get_special_notification!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_special_notification!(%Scope{} = scope, id) do
    Repo.get_by!(SpecialNotification, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a special_notification.

  ## Examples

      iex> create_special_notification(scope, %{field: value})
      {:ok, %SpecialNotification{}}

      iex> create_special_notification(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_special_notification(%Scope{} = scope, attrs) do
    with {:ok, special_notification = %SpecialNotification{}} <-
           %SpecialNotification{}
           |> SpecialNotification.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_special_notification(scope, {:created, special_notification})
      {:ok, special_notification}
    end
  end

  @doc """
  Updates a special_notification.

  ## Examples

      iex> update_special_notification(scope, special_notification, %{field: new_value})
      {:ok, %SpecialNotification{}}

      iex> update_special_notification(scope, special_notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_special_notification(%Scope{} = scope, %SpecialNotification{} = special_notification, attrs) do
    true = special_notification.user_id == scope.user.id

    with {:ok, special_notification = %SpecialNotification{}} <-
           special_notification
           |> SpecialNotification.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_special_notification(scope, {:updated, special_notification})
      {:ok, special_notification}
    end
  end

  @doc """
  Deletes a special_notification.

  ## Examples

      iex> delete_special_notification(scope, special_notification)
      {:ok, %SpecialNotification{}}

      iex> delete_special_notification(scope, special_notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_special_notification(%Scope{} = scope, %SpecialNotification{} = special_notification) do
    true = special_notification.user_id == scope.user.id

    with {:ok, special_notification = %SpecialNotification{}} <-
           Repo.delete(special_notification) do
      broadcast_special_notification(scope, {:deleted, special_notification})
      {:ok, special_notification}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking special_notification changes.

  ## Examples

      iex> change_special_notification(scope, special_notification)
      %Ecto.Changeset{data: %SpecialNotification{}}

  """
  def change_special_notification(%Scope{} = scope, %SpecialNotification{} = special_notification, attrs \\ %{}) do
    true = special_notification.user_id == scope.user.id

    SpecialNotification.changeset(special_notification, attrs, scope)
  end
end
