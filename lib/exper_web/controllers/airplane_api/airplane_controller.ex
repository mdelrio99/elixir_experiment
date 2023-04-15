defmodule ExperWeb.AirplaneController do
  use ExperWeb, :controller

  alias Exper.Library
  alias Exper.Library.Airplane

  action_fallback ExperWeb.FallbackController

  def index(conn, _params) do
    airplanes = Library.list_airplanes()
    render(conn, :index, airplanes: airplanes)
  end

  def create(conn, %{"airplane" => airplane_params}) do
    with {:ok, %Airplane{} = airplane} <- Library.create_airplane(airplane_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/airplanes/#{airplane}")
      |> render(:show, airplane: airplane)
    end
  end

  def show(conn, %{"id" => id}) do
    airplane = Library.get_airplane(id)

    if (is_nil(airplane)) do
        render(conn, :noresults)
    else
        render(conn, :show, airplane: airplane)
    end
  end

  def update(conn, %{"id" => id, "airplane" => airplane_params}) do
    airplane = Library.get_airplane(id)

    with {:ok, %Airplane{} = airplane} <- Library.update_airplane(airplane, airplane_params) do
      render(conn, :show, airplane: airplane)
    end
  end


  def delete(conn, %{"id" => id}) do
    airplane = Library.get_airplane!(id)

    with {:ok, %Airplane{}} <- Library.delete_airplane(airplane) do
      send_resp(conn, :no_content, "")
    end
  end
end
