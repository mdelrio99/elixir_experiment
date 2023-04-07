defmodule ExperWeb.DataTableLive.DatatableIndex do
  use ExperWeb, :live_view
  require Logger
  require CSV
  alias NimbleCSV.RFC4180, as: CSV2

  #CSV to write
  #NimbleCSV to read

  alias Exper.Library
  alias Exper.Library.Todo

  @dataOfInterest [:id, :task, :priority, :status, :category]

  @impl true
  def mount(_params, _session, socket) do
#    data = load_data()

    rawdata = Library.list_todos()

    sorteddata = rawdata
        |> Enum.map(fn x -> Map.take(x, @dataOfInterest) end)
        |> Enum.sort_by( fn x -> x.id end, :desc)

#    {:ok, stream(socket, :todos, Library.list_todos())}

    newsock = stream(socket, :todos, rawdata)

    latestsock = newsock
    |> assign(data: sorteddata)
    |> assign(coltosort: "Task")
    |> assign(search: "")
    |> assign(chgSetForForms: %{})

    {:ok,  latestsock }

  end


  def handle_event("row_clicked", _params, socket) do
#    def handle_event("row_clicked", %{"id" => id}, socket) do
      # Handle row click event
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Library.get_todo!(id)
    {:ok, _} = Library.delete_todo(todo)

    {:noreply, stream_delete( reloadData(socket) , :todos, todo)}
  end

  @impl true
  def handle_event("sort", %{"coltosort" => coltosort}, socket) do

      {:noreply, reloadData( assign(socket, coltosort: coltosort) )}
  end

  @impl true
  def handle_event("search_as_you_type",  %{"search" => search}, socket) do
#    changeset = changeset(%{}, params)
#    IO.inspect("VVVVVVVV")
#    IO.inspect(search)

    search = String.trim(search)

      data = Library.search_todos(search)
      |> Enum.map(fn x -> Map.take(x, @dataOfInterest) end)
      |> Enum.sort_by( fn x -> case socket.assigns.coltosort do
        "Priority" -> case x.priority do
                  "high" -> 1
                  "normal" -> 2
                  "low" -> 3
                  _ -> 3
        end
        "Task" -> -x.id
        "Status" -> case x.status do
                  "Not started" -> 1
                  "Started" -> 2
                  "Completed" ->3
                  _ -> 3
        end
        "Category" -> x.category
          _ -> -x.id
        end
      end)


      {:noreply, socket
              |> assign(data: data)
              |> assign(search: search) }
  end

  @impl true
  def handle_event("import-from-csv", _, socket) do
    csv_row_to_table_record("/tmp/todos-export-ordered.csv")

    {:noreply, reloadData(socket)}
  end


  @impl true
  def handle_event("backup-to-csv-ordered", _, socket) do

    fields_to_export = [:id, :task, :description, :priority, :status, :category, :datecompleted]

#    headerPortion = Library.list_todos
#    |> Enum.map(fn x -> Map.keys  (Map.take(x, fields_to_export)) end)
#    |> List.first()

    headerRow = fields_to_export
      |> Enum.map(  fn x -> "\"" <> Atom.to_string(x) <> "\"" end)
      |> Enum.join(",")

    csvData = Enum.map( Library.list_todos, fn amap -> build_ordered_list_for_CSV( fields_to_export, amap) end)
    |> Enum.map( fn orderedRecord -> Enum.join(orderedRecord, ",") end)
    |> Enum.join("\n")

    file = File.open!("/tmp/todos-export-ordered.csv", [:write, :utf8])
    IO.write(file, headerRow <> "\n" <> csvData)
    File.close(file)

    {:noreply, socket}
  end


  @impl true
  def handle_event("backup-to-csv", _, socket) do

    fields_to_export = [:id, :task, :description, :priority, :status, :category, :datecompleted]

    data = Library.list_todos
      |> Enum.map(fn x -> Map.values(Map.take(x, fields_to_export)) end)

    headerPortion = Library.list_todos
      |> Enum.map(fn x -> Map.keys  (Map.take(x, fields_to_export)) end)
      |> List.first()

    headerRow = headerPortion
      |> Enum.map(  fn x -> "\"" <> Atom.to_string(x) <> "\"" end)


    quoted_data = Enum.map(data, fn row -> Enum.map(row, &("\"#{&1}\"")) end)

    csv_data    = CSV.encode(quoted_data, quote: "'", escape: "\\", headers: false)

#####
    file = File.open!("/tmp/todos-export.csv", [:write, :utf8])
    IO.write(file, Enum.join(headerRow, ",") <> "\n")
    Enum.each(csv_data, &(IO.write(file, String.replace(&1, ~r"\"{3}", "\"") )))
    File.close(file)
#####

    {:noreply, socket}
  end

  def testz do
    IO.puts("disabled")
#    csv_row_to_table_record("/mnt/e/srcbk/todos-export.csv")
  end


  #----------------------------------


  defp build_ordered_list_for_CSV( fields, single_map_record ) do
    fieldDataInOrder = Enum.map(fields, fn field ->
                                      valS = Map.get( single_map_record,field, nil)
                                      valS = "#{valS}"
                                      if String.at(valS, 0) == '"', do: valS, else: "\"" <> valS <> "\""
                                    end)

    fieldDataInOrder
end

# def testordering() do
#   testmap = [
#       %{ :priority => "Important!", :task => "App: stuff one", :status => "Not Yet Started"},
#       %{ :priority => "whatever", :task => "Thing 2", :status => "Completed"}
#   ]

#   Enum.map(testmap, fn amap -> build_ordered_list( amap) end)
# #  build_ordered_list( testmap)
# end

def data_to_ordered_CSV do
  data = Library.list_todos

  fields = [ :task, :priority, :status]

  Enum.map( data, fn amap -> build_ordered_list_for_CSV( fields, amap) end)
  |> Enum.map( fn orderedRecord -> Enum.join(orderedRecord, ",") end)
  |> Enum.join("\n")
end

#------------------------------------------

def ellipsis(s, slen) do
  if (String.length(s) >slen), do: String.slice(s, 0, slen) <> "...", else: s
end


def create_or_skip(row) do
    Exper.Library.create_todo(row)
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

defp get_column_names(file) do
  file
  |> File.stream!()
  |> CSV2.parse_stream(skip_headers: false)
  |> Enum.fetch!(0)
  |> Enum.with_index()
  |> Map.new(fn {val, num} -> {num, val} end)
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

  defp apply_action(socket, :main, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

#  def handle_event("refresh", _params, socket) do
#    {:noreply, Phoenix.LiveView.push_patch(socket, to: socket.public_url)}
#  end

  @impl true
  def handle_info({ExperWeb.DataTableLive.FormComponent, {:saved, todo}}, socket) do

    {:noreply, stream_insert( reloadData(socket) , :todos, todo)}
  end

  defp fetchData(socket) do
      search = socket.assigns.search
      if search == "", do: Library.list_todos, else: Library.search_todos(search)
  end

  defp reloadData(socket) do
    data = fetchData(socket)
        |> Enum.map(fn x -> Map.take(x, @dataOfInterest) end)
        |> Enum.sort_by( fn x -> case socket.assigns.coltosort do
          "Priority" -> case x.priority do
                    "high" -> 1
                    "normal" -> case x.status do
                      "Started" -> 1
                      "Not started" -> 2
                      _ -> 3
                    end
                    "low" -> 4
                    _ -> 3
          end
          "Task" -> -x.id
          "Status" -> case x.status do
                    "Not started" -> 1
                    "Started" -> 2
                    "Completed" ->3
                    _ -> 3
          end
          "Category" -> x.category
          _ -> -x.id
        end
      end)

      assign(socket, data: data)
  end






end
