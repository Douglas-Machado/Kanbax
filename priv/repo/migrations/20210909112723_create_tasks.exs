defmodule Kanbax.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :state_id, references(:state)

      timestamps()
    end

  end
end
