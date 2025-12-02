defmodule Services.Repo.Migrations.AlterSpecialNotifications do
  use Ecto.Migration

  def change do
    alter table(:special_notifications) do
      add :to_id,
          references(:users, on_delete: :nothing, type: :binary_id)
    end
    create index(:special_notifications, [:to_id])
  end
end
