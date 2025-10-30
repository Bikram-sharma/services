defmodule Services.ServiceProvider do
  @moduledoc """
  The ServiceProvider context.
  """

  import Ecto.Query, warn: false
  alias Services.Repo

  alias Services.ServiceProvider.Provider
  alias Services.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any provider changes.

  The broadcasted messages match the pattern:

    * {:created, %Provider{}}
    * {:updated, %Provider{}}
    * {:deleted, %Provider{}}

  """
  def subscribe_service_providers(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Services.PubSub, "user:#{key}:service_providers")
  end

  defp broadcast_provider(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Services.PubSub, "user:#{key}:service_providers", message)
  end

  @doc """
  Returns the list of service_providers.

  ## Examples

      iex> list_service_providers(scope)
      [%Provider{}, ...]

  """
  def list_service_providers(%Scope{} = scope) do
    Repo.all_by(Provider, user_id: scope.user.id)
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.

  ## Examples

      iex> get_provider!(scope, 123)
      %Provider{}

      iex> get_provider!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_provider!(%Scope{} = scope, id) do
    Repo.get_by!(Provider, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a provider.

  ## Examples

      iex> create_provider(scope, %{field: value})
      {:ok, %Provider{}}

      iex> create_provider(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

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

  ## Examples

      iex> update_provider(scope, provider, %{field: new_value})
      {:ok, %Provider{}}

      iex> update_provider(scope, provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

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

  ## Examples

      iex> delete_provider(scope, provider)
      {:ok, %Provider{}}

      iex> delete_provider(scope, provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider(%Scope{} = scope, %Provider{} = provider) do
    true = provider.user_id == scope.user.id

    with {:ok, provider = %Provider{}} <-
           Repo.delete(provider) do
      broadcast_provider(scope, {:deleted, provider})
      {:ok, provider}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.

  ## Examples

      iex> change_provider(scope, provider)
      %Ecto.Changeset{data: %Provider{}}

  """
  def change_provider(%Scope{} = scope, %Provider{} = provider, attrs \\ %{}) do
    true = provider.user_id == scope.user.id

    Provider.changeset(provider, attrs, scope)
  end
end
