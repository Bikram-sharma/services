defmodule Services.Service_provider.Provider do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "provider" do
    field :bio, :string
    field :experience_year, :integer
    field :is_verified, :boolean, default: false

    belongs_to :user, Services.Accounts.User,
      foreign_key: :user_id,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end


  @doc false
  def changeset(provider, attrs, user_scope) do
    provider
    |> cast(attrs, [:bio, :experience_year, :is_verified])
    |> validate_required([:bio, :experience_year, :is_verified])
    |> put_change(:user_id, user_scope.user.id)
  end
end
