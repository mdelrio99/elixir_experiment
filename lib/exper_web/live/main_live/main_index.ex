defmodule ExperWeb.MainLive.MainIndex do
  use ExperWeb, :live_view

#  alias Exper.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket} #stream(socket, :books, Library.list_books())}
  end

end
