defmodule ExperWeb.TodoController do
  use ExperWeb, :controller

  alias Exper.Library
  alias Exper.Library.Todo

  action_fallback ExperWeb.FallbackController

  def index(conn, _params) do
    todos = Library.list_todos()
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Library.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Library.get_todo(id)

    if (is_nil(todo)) do
        render(conn, :noresults)
    else
        render(conn, :show, todo: todo)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Library.get_todo(id)

    with {:ok, %Todo{} = todo} <- Library.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end


  def delete(conn, %{"id" => id}) do
    todo = Library.get_todo!(id)

    with {:ok, %Todo{}} <- Library.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
