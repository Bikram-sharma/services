defmodule Services.Service_provider do
  @moduledoc """
  The Service_provider context.
  """
  import Ecto.Query, warn: false
  alias Services.Repo

  alias Services.Service_provider.Provider
  alias Services.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any provider changes.

  The broadcasted messages match the pattern:

    * {:created, %Provider{}}
    * {:updated, %Provider{}}
    * {:deleted, %Provider{}}
  """
  def subscribe_provider(%Scope{} = scope) do
    key = scope.user.id
    Phoenix.PubSub.subscribe(Services.PubSub, "user:#{key}:provider")
  end

  defp broadcast_provider(%Scope{} = scope, message) do
    key = scope.user.id
    Phoenix.PubSub.broadcast(Services.PubSub, "user:#{key}:provider", message)
  end

  @doc """
  Returns the list of provider scoped to the given scope.
  """
  def list_provider(%Scope{} = scope) do
    from(p in Provider, where: p.user_id == ^scope.user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.
  """
  def get_provider!(%Scope{} = scope, id) do
    Repo.get_by!(Provider, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a provider.
  """
  def create_provider(%Scope{} = scope, attrs) do
    with {:ok, provider = %Provider{}} <-
           %Provider{}
           |> Provider.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_provider(scope, {:created, provider})
      {:ok, provider}
    end
  end

  @doc """
  Updates a provider.
  """
  def update_provider(%Scope{} = scope, %Provider{} = provider, attrs) do
    true = provider.user_id == scope.user.id

    with {:ok, provider = %Provider{}} <-
           provider
           |> Provider.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_provider(scope, {:updated, provider})
      {:ok, provider}
    end
  end

  @doc """
  Deletes a provider.
  """
  def delete_provider(%Scope{} = scope, %Provider{} = provider) do
    true = provider.user_id == scope.user.id

    with {:ok, provider = %Provider{}} <- Repo.delete(provider) do
      broadcast_provider(scope, {:deleted, provider})
      {:ok, provider}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.
  """
  def change_provider(%Scope{} = scope, %Provider{} = provider, attrs \\ %{}) do
    true = provider.user_id == scope.user.id
    Provider.changeset(provider, attrs, scope)
  end
end
