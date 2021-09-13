defmodule Kanbax.Kanban.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kanbax.Kanban.Status
  alias Kanbax.Accounts.User

  @require_params [:title, :description, :status_id, :reporter_id]

  schema "tasks" do
    field :title, :string
    field :description, :string

    belongs_to :status, Status
    belongs_to :reporter, User, foreign_key: :reporter_id
    belongs_to :executor, User, foreign_key: :executor_id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @require_params)
    |> validate_required([:title, :description])

  end
end
