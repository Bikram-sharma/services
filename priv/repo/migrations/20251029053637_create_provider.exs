defmodule Services.Repo.Migrations.CreateProvider do
  use Ecto.Migration

  def change do
    create table(:provider, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :bio, :text
      add :experience_year, :integer
      add :is_verified, :boolean, default: false, null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:provider, [:user_id])
  end
end
