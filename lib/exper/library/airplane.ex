defmodule Exper.Library.Airplane do
  use Ecto.Schema
  import Ecto.Changeset

  schema "airplanes" do
    field :model, :string
    field :year, :string
    field :url, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(airplane, attrs) do
    airplane
    |> cast(attrs, [:model, :year, :url, :price])
    |> validate_required([:model, :year, :url, :price])
  end
end
