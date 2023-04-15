defmodule ExperWeb.AirplaneJSON do
  alias Exper.Library.Airplane

  @doc """
  Renders a list of airplanes.
  """
  def index(%{airplanes: airplanes}) do
    %{data: for(airplane <- airplanes, do: data(airplane))}
  end

  @doc """
  Renders a single airplane.
  """
  def show(%{airplane: airplane}) do
    %{data: data(airplane)}
  end


  defp data(%Airplane{} = airplane) do
    %{
      id: airplane.id,
      model: airplane.model,
      year: airplane.year,
      url: airplane.url,
      price: airplane.price
        }
  end

  def noresults(%{}) do
    %{}
  end

end
