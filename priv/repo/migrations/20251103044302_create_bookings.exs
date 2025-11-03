defmodule Services.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :schedule_date_time, :utc_datetime
      add :booked_at, :utc_datetime
      add :cancelled_at, :utc_datetime
      add :cancelled_by, :string
      add :actual_total_price, :decimal
      add :user_address, :string
      add :provider_service_id, references(:providers_service, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:user_id])
    create index(:bookings, [:provider_service_id])
  end
end
