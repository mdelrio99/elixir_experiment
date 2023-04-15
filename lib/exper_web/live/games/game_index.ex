defmodule ExperWeb.GameLive.GameIndex do
#  use ExperWeb, :live_view
#  use layout: {MyAppWeb.LayoutView, "simple_app.html"}
  use ExperWeb, :live_view
#  use Phoenix.LiveView layout: {MyAppWeb.LayoutView, "app.html"}


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign(pageLayout: "skip"), layout: false
    }
  end


end
