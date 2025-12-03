defmodule Services.Repo.Migrations.AlterProvidersService do
  use Ecto.Migration

  def change do
    alter table(:providers_service) do
      add :descriptions, :text
    end
  end
end
