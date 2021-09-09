defmodule Kanbax.Repo.Migrations.CreateState do
  use Ecto.Migration

  def change do
    create table(:state) do
      add :title, :string

      timestamps()
    end

  end
end
