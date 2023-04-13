defmodule Exper.Library.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :task, :string
    field :description, :string
    field :priority, :string
    field :status, :string
    field :category, :string
    field :datecompleted, :date

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:task, :description, :priority, :status, :category, :datecompleted])
    |> validate_required([:task, :priority])
    |> unique_constraint(
      :task,
      name: :index_for_todos_duplicate_entries
    )
  end
end
