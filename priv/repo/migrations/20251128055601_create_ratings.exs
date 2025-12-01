defmodule Services.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :rating, :integer
      add :comment, :text
      add :rated_user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :rated_service_id, references(:providers_service, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:ratings, [:rated_user_id])
    create index(:ratings, [:rated_service_id])
  end
end
