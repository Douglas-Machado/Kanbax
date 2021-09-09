defmodule Kanbax.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :publicist_id, references(:users, on_delete: :nothing)
      add :reporter_id, references(:users, on_delete: :nothing)
      add :column_id, references(:columns, on_delete: :nothing)

      timestamps()
    end

  end
end
