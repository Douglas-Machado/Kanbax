defmodule Kanbax.Kanban.Status do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kanbax.Kanban.Task

  schema "state" do
    field :title, :string

    has_many :tasks, Task

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
