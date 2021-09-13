defmodule Kanbax.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status_id, references(:status)
      add :reporter_id, references(:users)
      add :executor_id, references(:users)

      timestamps()
    end

  end
end
