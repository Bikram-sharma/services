defmodule Services.Repo.Migrations.AlterProvidersServices do
  use Ecto.Migration

  def change do
    alter table(:providers_service) do
      remove :user_id
    end
  end
end
