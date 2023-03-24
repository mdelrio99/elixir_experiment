defmodule ExperWeb.AirplaneLive.Show do
  use ExperWeb, :live_view

  alias Exper.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:airplane, Library.get_airplane!(id))}
  end

  defp page_title(:show), do: "Show Airplane"
  defp page_title(:edit), do: "Edit Airplane"
  defp page_title(:view), do: "View Airplane"

end
