defmodule Todolist.Repo.Migrations.AddRoleUtilsateur do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :boolean
      add :password, :string
    end
  end
end
