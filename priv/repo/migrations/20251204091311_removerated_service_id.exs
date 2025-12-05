defmodule Services.Repo.Migrations.RemoveratedServiceId do
  use Ecto.Migration

  def change do
    alter table(:ratings) do
      remove :rated_service_id
    end
  end
end
