defmodule Kanbax.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :description, :string

      timestamps()
    end
  end
end
