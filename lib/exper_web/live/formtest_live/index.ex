defmodule ExperWeb.FtestLive.Index do
  use ExperWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(chgSetForForms: %{})}
  end


  @impl true
  def handle_event("search_as_you_type",  %{"search" => search}, socket) do
#    changeset = changeset(%{}, params)
IO.inspect("VVVVVVVV")
IO.inspect(search)
{:noreply, socket}
  end

  @impl true
  def handle_event("save_neverhit", %{"search" => search}, socket) do
#    changeset = changeset(%{}, params)
    IO.inspect("SSSSSSSSSS")
    IO.inspect(search)

    {:noreply, socket}
  end

end
