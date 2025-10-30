defmodule Services.ProviderService do
  @moduledoc """
  The ProviderService context.
  """

  import Ecto.Query, warn: false
  alias Services.Repo

  alias Services.ProviderService.ProvidersService
  alias Services.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any providers_service changes.

  The broadcasted messages match the pattern:

    * {:created, %ProvidersService{}}
    * {:updated, %ProvidersService{}}
    * {:deleted, %ProvidersService{}}

  """
  def subscribe_providers_service(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Services.PubSub, "user:#{key}:providers_service")
  end

  defp broadcast_providers_service(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Services.PubSub, "user:#{key}:providers_service", message)
  end

  @doc """
  Returns the list of providers_service.

  ## Examples

      iex> list_providers_service(scope)
      [%ProvidersService{}, ...]

  """
  def list_providers_service(%Scope{} = scope) do
    Repo.all_by(ProvidersService, user_id: scope.user.id)
  end

  @doc """
  Gets a single providers_service.

  Raises `Ecto.NoResultsError` if the Providers service does not exist.

  ## Examples

      iex> get_providers_service!(scope, 123)
      %ProvidersService{}

      iex> get_providers_service!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_providers_service!(%Scope{} = scope, id) do
    Repo.get_by!(ProvidersService, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a providers_service.

  ## Examples

      iex> create_providers_service(scope, %{field: value})
      {:ok, %ProvidersService{}}

      iex> create_providers_service(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_providers_service(%Scope{} = scope, attrs) do
    with {:ok, providers_service = %ProvidersService{}} <-
           %ProvidersService{}
           |> ProvidersService.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_providers_service(scope, {:created, providers_service})
      {:ok, providers_service}
    end
  end

  @doc """
  Updates a providers_service.

  ## Examples

      iex> update_providers_service(scope, providers_service, %{field: new_value})
      {:ok, %ProvidersService{}}

      iex> update_providers_service(scope, providers_service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_providers_service(%Scope{} = scope, %ProvidersService{} = providers_service, attrs) do
    true = providers_service.user_id == scope.user.id

    with {:ok, providers_service = %ProvidersService{}} <-
           providers_service
           |> ProvidersService.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_providers_service(scope, {:updated, providers_service})
      {:ok, providers_service}
    end
  end

  @doc """
  Deletes a providers_service.

  ## Examples

      iex> delete_providers_service(scope, providers_service)
      {:ok, %ProvidersService{}}

      iex> delete_providers_service(scope, providers_service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_providers_service(%Scope{} = scope, %ProvidersService{} = providers_service) do
    true = providers_service.user_id == scope.user.id

    with {:ok, providers_service = %ProvidersService{}} <-
           Repo.delete(providers_service) do
      broadcast_providers_service(scope, {:deleted, providers_service})
      {:ok, providers_service}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking providers_service changes.

  ## Examples

      iex> change_providers_service(scope, providers_service)
      %Ecto.Changeset{data: %ProvidersService{}}

  """
  def change_providers_service(%Scope{} = scope, %ProvidersService{} = providers_service, attrs \\ %{}) do
    true = providers_service.user_id == scope.user.id

    ProvidersService.changeset(providers_service, attrs, scope)
  end
end
