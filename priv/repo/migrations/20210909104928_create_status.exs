defmodule Kanbax.Repo.Migrations.CreateStatus do
  use Ecto.Migration

  def change do
    create table(:status) do
      add :title, :string

      timestamps()
    end

  end
end
