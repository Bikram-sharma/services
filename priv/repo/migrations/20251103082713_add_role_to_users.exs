defmodule Services.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
     alter table(:users) do
        add :role, :string, default: "client", null: false
      end
  end
end
