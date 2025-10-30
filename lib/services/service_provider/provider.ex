defmodule Services.ServiceProvider.Provider do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "service_providers" do
    field :bio, :string
    field :years_of_experience, :integer
    field :is_verified, :boolean, default: false

    belongs_to :users, Services.Accounts.User,
      foreign_key: :user_id,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(provider, attrs, user_scope) do
    provider
    |> cast(attrs, [:bio, :years_of_experience, :is_verified])
    |> validate_required([:bio, :years_of_experience, :is_verified])
    |> put_change(:user_id, user_scope.user.id)
  end
end
