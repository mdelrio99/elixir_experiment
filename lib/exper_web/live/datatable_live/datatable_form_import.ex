defmodule ExperWeb.DataTableLive.FormPopulate do
  use ExperWeb, :live_view

  alias Exper.Library
  alias NimbleCSV.RFC4180, as: CSV2

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     }
  end


  def create_or_skip(row) do
#    IO.inspect("@@>>")
    IO.inspect(row)

    Library.create_todo(row)
end



  @impl true
  def handle_event("submitForm", %{"importedCSV" => importedCSV}, socket) do
#  def handle_event("submitForm", value, socket) do


    parsed_data = CSV2.parse_string(importedCSV)

    alldata = String.split(importedCSV, "\n")

    {column_names_str, remainder} = List.pop_at(alldata, 0)

    column_names_first = String.split(column_names_str, ",")
 #   IO.inspect(column_names)

#    column_names = [:id, :model, :year, :url, :price]
    column_names = [:id, :task, :description, :priority, :status, :category, :datecompleted]

     parsed_data
     |> Enum.map(fn row ->
       row
       |> Enum.with_index()
       |> Map.new(fn {val, num} -> {Enum.at(column_names,num), val} end)
       |> create_or_skip()
     end)


    {:noreply, socket}
  end


  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
  defp page_title(:new), do: "Post Todos"

end
