defmodule Services.Repo.Migrations.CreateServiceProviders do
  use Ecto.Migration

  def change do
    create table(:service_providers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :bio, :text
      add :years_of_experience, :integer
      add :is_verified, :boolean, default: false, null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:service_providers, [:user_id])
  end
end
