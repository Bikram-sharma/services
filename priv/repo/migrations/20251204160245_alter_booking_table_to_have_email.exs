defmodule Services.Repo.Migrations.AlterBookingTableToHaveEmail do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :user_email, references(:users, column: :email, type: :citext, on_delete: :delete_all)
    end
  end
end
