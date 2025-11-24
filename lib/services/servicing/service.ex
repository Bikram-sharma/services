defmodule Services.Servicing.Service do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :name, :string
    field :description, :string
    field :user_id, :binary_id

    belongs_to :category, Services.Servicing.Category,
      foreign_key: :category_id,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs, user_scope) do
    service
    |> cast(attrs, [:name, :description, :category_id])
    |> validate_required([:name, :description, :category_id])
    |> put_change(:user_id, user_scope.user.id)
  end


  def changeset_admin(service, attrs) do
    service
    |> cast(attrs, [:name, :description, :category_id])
    |> validate_required([:name, :description , :category_id])
  end
end
