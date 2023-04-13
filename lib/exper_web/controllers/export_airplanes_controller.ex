defmodule ExperWeb.ExportAirplanesController do
  use ExperWeb, :controller

#  alias CsvdownWeb.Customers
  alias Exper.Library

  def create(conn, _params) do
    fields_to_export = [:id, :model, :year, :url, :price]

#    headerPortion = Library.list_todos
#    |> Enum.map(fn x -> Map.keys  (Map.take(x, fields_to_export)) end)
#    |> List.first()

    headerRow = fields_to_export
      |> Enum.map(  fn x -> "\"" <> Atom.to_string(x) <> "\"" end)
      |> Enum.join(",")

    csvData = Enum.map( Library.list_airplanes, fn amap ->
          Exper.build_ordered_list_for_CSV( fields_to_export, amap) end)
    |> Enum.map( fn orderedRecord -> Enum.join(orderedRecord, ",") end)
    |> Enum.join("\n")


    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"airplanes-export.csv\"")
#    |> put_root_layout(false)
    |> send_resp(200, headerRow <> "\n" <> csvData)
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
