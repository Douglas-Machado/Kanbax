defmodule Kanbax.Kanban.Column do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kanbax.Kanban.Board

  schema "columns" do
    field :title, :string

    belongs_to :board, Board

    timestamps()
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
