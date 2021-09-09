defmodule Kanbax.Kanban.Board do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kanbax.Kanban.Column

  schema "boards" do
    field :description, :string
    field :title, :string

    has_many :column, Column

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
