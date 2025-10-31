defmodule Services.ProviderService.ProvidersService do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "providers_service" do
    field :custom_price, :decimal
    field :is_available, :boolean, default: false


    belongs_to :service_providers ,Services.ServiceProvider.Provider,
      foreign_key: :service_provider_id,
      type: :binary_id

    belongs_to :services ,Services.ServiceProvider.Provider,
      foreign_key: :service_id,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(providers_service, attrs, user_scope) do
    providers_service
    |> cast(attrs, [:custom_price, :is_available])
    |> validate_required([:custom_price, :is_available])

  end
end
