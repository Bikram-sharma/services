defmodule Services.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ratings" do
    field :rating, :integer
    field :comment, :string

    belongs_to :users, Services.Accounts.User,
        foreign_key: :rated_user_id,
        type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs, user_scope) do
    rating
    |> cast(attrs, [:rating, :comment])
    |> validate_required([:rating, :comment])
    |> put_change(:rated_user_id, user_scope.user.id)
  end
end
