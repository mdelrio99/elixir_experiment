defmodule ExperWeb.AirplaneLive.FormPopulate do
  use ExperWeb, :live_view

  alias Exper.Library
  alias NimbleCSV.RFC4180, as: CSV2

  @impl true
  def mount(_params, _session, socket) do

#    {:ok, push_event(socket, "call_JS", %{data: "a lot of stuff goes here"})}
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:csv_data, "")
     |> assign(:csv_line_error_info, "1,2")
     |> assign(:csv_detailed_error_info, "stuff")
     }
  end


  def create_or_skip(row) do
#    IO.inspect("@@>>")
    IO.inspect(row)

    Library.create_airplane(row)
end



  @impl true
  def handle_event("submitForm", %{"importedCSV" => importedCSV}, socket) do
#  def handle_event("submitForm", value, socket) do


  {:ok, file} = File.open("/tmp/csv_test.csv", [:write])

  IO.puts(file, importedCSV)

  :ok = File.close(file)

  results = "/tmp/csv_test.csv"
  |> Path.expand(__DIR__)
  |> File.stream!([:trim_bom])
  |> CSV.decode()
  |> Enum.take(1000000)

  #IO.inspect( results )

  error_stats = Enum.reduce(results, {"", 0, 0, ""},
    fn (element, {error_messages, acc, linenum, lines_w_errs}) ->

      case element do
        {:ok, _data} -> {error_messages, acc, linenum+1, lines_w_errs}
        {:error, message} ->
#          IO.puts("Error: #{inspect message}")
          {error_messages <> "|" <> message, acc+1, linenum+1, lines_w_errs <> "|" <> Integer.to_string(linenum+1)}
      end

  end)



  # stream = importedCSV
  #       |> String.to_charlist()
  #       |> Stream.cycle()

  # IO.inspect(
  #     stream
  #       |> CSV.decode()
  # )



      # redirect to the success page
      case elem(error_stats, 1) do
        0 ->
            parsed_data = CSV2.parse_string(importedCSV)

            alldata = String.split(importedCSV, "\n")

            {column_names_str, remainder} = List.pop_at(alldata, 0)

            column_names_first = String.split(column_names_str, ",")
        #   IO.inspect(column_names)

            column_names = [:id, :model, :year, :url, :price]
        #    column_names = [:id, :task, :description, :priority, :status, :category, :datecompleted]


            parsed_data
            |> Enum.map(fn row ->
              row
              |> Enum.with_index()
              |> Map.new(fn {val, num} -> {Enum.at(column_names,num), val} end)
              |> create_or_skip()
            end)


          {:noreply,
          socket
            |> put_flash(:info, "Import Success!")
            |> redirect(to: "/airplanes")}
        _ ->
          {:noreply,
          socket
          |> assign(:csv_data, importedCSV)
          |> assign(:csv_line_error_info, elem(error_stats, 3))
          |> assign(:csv_detailed_error_info, elem(error_stats, 0))
          |> put_flash(:error, "There were errors Importing!" )
          |> push_event( "show_csv_errors", %{lineinfo: elem(error_stats, 3), msgs: elem(error_stats, 0)})}
      end

    end

    def handle_event("jsEventToPhx", _params, socket) do
      {:reply, %{hello: "world"}, socket}
    end

  defp page_title(:index), do: "Post Airplanes"

end
