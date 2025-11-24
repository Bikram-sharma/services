defmodule Services.Repo.Migrations.CreateProvidersService do
  use Ecto.Migration

  def change do
    create table(:providers_service, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :custom_price, :decimal
      add :is_available, :boolean, default: false, null: false

      add :service_provider_id,
          references(:service_providers, on_delete: :nothing, type: :binary_id)

      add :service_id, references(:services, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:providers_service, [:user_id])

    create index(:providers_service, [:service_provider_id])
    create index(:providers_service, [:service_id])
  end
end
