defmodule Kanbax.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status_id, references(:status)

      timestamps()
    end

  end
end
