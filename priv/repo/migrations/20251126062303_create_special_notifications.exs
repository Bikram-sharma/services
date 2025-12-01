defmodule Services.Repo.Migrations.CreateSpecialNotifications do
  use Ecto.Migration

  def change do
    create table(:special_notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :archive, :boolean, default: false, null: false
      add :read, :boolean, default: false, null: false
      add :booking_id, references(:bookings, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:special_notifications, [:user_id])

    create index(:special_notifications, [:booking_id])
  end
end
