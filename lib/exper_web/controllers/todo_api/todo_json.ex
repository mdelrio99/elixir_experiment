defmodule ExperWeb.TodoJSON do
  alias Exper.Library.Todo

  @doc """
  Renders a list of todos.
  """
  def index(%{todos: todos}) do
    %{data: for(todo <- todos, do: data(todo))}
  end

  @doc """
  Renders a single todo.
  """
  def show(%{todo: todo}) do
    %{data: data(todo)}
  end

  def show(%{todo: todo}) do
    %{data: data(todo)}
  end


  defp data(%Todo{} = todo) do
    %{
      id: todo.id,
      task: todo.task,
      description: todo.description,
      priority: todo.priority,
      status: todo.status,
      category: todo.category,
      datecompleted: todo.datecompleted
        }
  end

  def noresults(%{}) do
    %{}
  end

end
