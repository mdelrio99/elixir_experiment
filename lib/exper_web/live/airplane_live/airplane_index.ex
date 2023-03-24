defmodule ExperWeb.AirplaneLive.AirplaneIndex do
  use ExperWeb, :live_view

  alias Exper.Library
  alias Exper.Library.Airplane

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :airplanes, Library.list_airplanes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Airplane")
    |> assign(:airplane, Library.get_airplane!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Airplane")
    |> assign(:airplane, %Airplane{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Airplane")
    |> assign(:airplane, nil)
  end

  @impl true
  def handle_info({ExperWeb.AirplaneLive.FormComponent, {:saved, airplane}}, socket) do
    {:noreply, stream_insert(socket, :airplanes, airplane)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    airplane = Library.get_airplane!(id)
    {:ok, _} = Library.delete_airplane(airplane)

    {:noreply, stream_delete(socket, :airplanes, airplane)}
  end
end
