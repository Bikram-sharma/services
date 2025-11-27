defmodule Services.Repo.Migrations.AlterBookingsTable do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :initiated_at, :utc_datetime
      add :booking_status, :string
      add :contact, :string
      add :payment_status, :string
      add :delivered_at, :utc_datetime
      add :accepted_at, :utc_datetime
    end
  end
end
