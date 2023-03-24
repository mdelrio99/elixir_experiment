defmodule ExperWeb.AnimLive.AnimIndex do
  use ExperWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign(search: "")
    |> assign(feedback: "")
    |> assign(chgSetForForms: %{})}
  end


  @impl true
  def handle_event("search",  %{"search" => search}, socket) do
#    changeset = changeset(%{}, params)
IO.inspect("VVVVVVVV")
IO.inspect(search)
{:noreply, assign(socket, feedback: "Whacka")}
  end

  @impl true
  def handle_event("get_next_rand", _, socket) do
#    changeset = changeset(%{}, params)
IO.inspect("ZZZ")
{:noreply, assign(socket, feedback: "22")}
  end


  @impl true
  def handle_event("save_neverhit", %{"search" => search}, socket) do
#    changeset = changeset(%{}, params)
    IO.inspect("SSSSSSSSSS")
    IO.inspect(search)

    {:noreply, socket}
  end

end
