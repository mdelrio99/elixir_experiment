defmodule ExperWeb.AirplaneLive.AirplaneIndex do
  use ExperWeb, :live_view

  alias Exper.Library
  alias Exper.Library.Airplane
  alias NimbleCSV.RFC4180, as: CSV2

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

  defp reloadData(s) do
    s
  end


  @impl true
  def handle_event("import-from-csv", _, socket) do
    csv_row_to_table_record("/tmp/airplanes-export-ordered.csv")

    {:noreply, reloadData(socket)}
  end


  @impl true
  def handle_event("backup-to-csv-ordered", _, socket) do

    fields_to_export = [:id, :model, :year, :url, :price]

#    headerPortion = Library.list_todos
#    |> Enum.map(fn x -> Map.keys  (Map.take(x, fields_to_export)) end)
#    |> List.first()

    headerRow = fields_to_export
      |> Enum.map(  fn x -> "\"" <> Atom.to_string(x) <> "\"" end)
      |> Enum.join(",")

    csvData = Enum.map( Library.list_airplanes, fn amap -> build_ordered_list_for_CSV( fields_to_export, amap) end)
    |> Enum.map( fn orderedRecord -> Enum.join(orderedRecord, ",") end)
    |> Enum.join("\n")

    file = File.open!("/tmp/airplanes-export-ordered.csv", [:write, :utf8])
    IO.write(file, headerRow <> "\n" <> csvData)
    File.close(file)

    {:noreply, socket}
  end


  defp build_ordered_list_for_CSV( fields, single_map_record ) do
    fieldDataInOrder = Enum.map(fields, fn field ->
                                      valS = Map.get( single_map_record,field, nil)
                                      valS = "#{valS}"
                                      if String.at(valS, 0) == '"', do: valS, else: "\"" <> valS <> "\""
                                    end)

    fieldDataInOrder
end


  def create_or_skip(row) do
    Exper.Library.create_airplane(row)
  end

  defp get_column_names(file) do
    file
    |> File.stream!()
    |> CSV2.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)
  end

  def csv_row_to_table_record(file) do
      column_names = get_column_names(file)

      file
      |> File.stream!()
      |> CSV2.parse_stream(skip_headers: true)
      |> Enum.map(fn row ->
        row
        |> Enum.with_index()
        |> Map.new(fn {val, num} -> {column_names[num], val} end)
        |> create_or_skip()
      end)

    end

end
