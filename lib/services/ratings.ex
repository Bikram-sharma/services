defmodule Services.Ratings do
  use Ecto.Schema

  alias Services.Repo

  alias Services.Ratings.Rating
  alias Services.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any rating changes.

  The broadcasted messages match the pattern:

    * {:created, %Rating{}}
    * {:updated, %Rating{}}
    * {:deleted, %Rating{}}

  """
  def subscribe_ratings(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Services.PubSub, "user:#{key}:ratings")
  end

  defp broadcast_rating(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Services.PubSub, "user:#{key}:ratings", message)
  end

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings(scope)
      [%Rating{}, ...]

  """
  def list_ratings(%Scope{} = scope) do
    Repo.all_by(Rating, rated_user_id: scope.user.id)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(scope, 123)
      %Rating{}

      iex> get_rating!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(%Scope{} = scope, id) do
    Repo.get_by!(Rating, id: id, rated_user_id: scope.user.id)
  end

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(scope, %{field: value})
      {:ok, %Rating{}}

      iex> create_rating(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(%Scope{} = scope, attrs) do
    with {:ok, rating = %Rating{}} <-
           %Rating{}
           |> Rating.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_rating(scope, {:created, rating})
      {:ok, rating}
    end
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(scope, rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(scope, rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Scope{} = scope, %Rating{} = rating, attrs) do
    true = rating.rated_user_id == scope.user.id

    with {:ok, rating = %Rating{}} <-
           rating
           |> Rating.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_rating(scope, {:updated, rating})
      {:ok, rating}
    end
  end

  @doc """
  Deletes a rating.

  ## Examples

      iex> delete_rating(scope, rating)
      {:ok, %Rating{}}

      iex> delete_rating(scope, rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Scope{} = scope, %Rating{} = rating) do
    true = rating.rated_user_id == scope.user.id

    with {:ok, rating = %Rating{}} <-
           Repo.delete(rating) do
      broadcast_rating(scope, {:deleted, rating})
      {:ok, rating}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(scope, rating)
      %Ecto.Changeset{data: %Rating{}}

  """
  def change_rating(%Scope{} = scope, %Rating{} = rating, attrs \\ %{}) do
    true = rating.rated_user_id == scope.user.id

    Rating.changeset(rating, attrs, scope)
  end
end
