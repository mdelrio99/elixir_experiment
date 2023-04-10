defmodule ExperWeb.CSVPostImportTodosController do
  use ExperWeb, :controller

#  alias CsvdownWeb.Customers
  alias Exper.Library

  def index(conn, _params) do
    conn
    |> send_resp(200, "Do a Post of CSV data to this endpoint to import todos")

#    |> put_resp_content_type("text/csv")
#    |> send_resp(200, "hello")
  end

  def create(conn, _params) do

    conn
    |> send_resp(200, "Importing?")


#     fields_to_export = [:task, :description, :priority, :status, :category, :datecompleted]

# #    headerPortion = Library.list_todos
# #    |> Enum.map(fn x -> Map.keys  (Map.take(x, fields_to_export)) end)
# #    |> List.first()

#     headerRow = fields_to_export
#       |> Enum.map(  fn x -> "\"" <> Atom.to_string(x) <> "\"" end)
#       |> Enum.join(",")

#     csvData = Enum.map( Library.list_todos, fn amap ->
#           ExperWeb.DataTableLive.DatatableIndex.build_ordered_list_for_CSV( fields_to_export, amap) end)
#     |> Enum.map( fn orderedRecord -> Enum.join(orderedRecord, ",") end)
#     |> Enum.join("\n")


#     conn
#     |> put_resp_content_type("text/csv")
#     |> put_resp_header("content-disposition", "attachment; filename=\"todos-export.csv\"")
# #    |> put_root_layout(false)
#     |> send_resp(200, headerRow <> "\n" <> csvData)
  end


  defp csv_content(records, fields) do

    IO.inspect("YXXXXXXXXXXXXXx")
    IO.inspect(records
    |> Enum.map(fn record ->
      record
      |> Map.from_struct()
      |> Map.take([]) # gives an empty map
      |> Map.merge( Map.take(record, fields) )
      |> Map.values()
    end)
    |> CSV.encode()
    |> Enum.to_list())

    records
    |> Enum.map(fn record ->
      record
      |> Map.from_struct()
      |> Map.take([]) # gives an empty map
      |> Map.merge( Map.take(record, fields) )
      |> Map.values()
    end)
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end
end
