defmodule ExperWeb.TodoLive.TodoIndex do
  use ExperWeb, :live_view

  alias Exper.Library
  alias Exper.Library.Todo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :todos, Library.list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Library.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({ExperWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Library.get_todo!(id)
    {:ok, _} = Library.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end
end
