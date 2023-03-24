defmodule Exper.Repo.Migrations.AddAirplane do
  use Ecto.Migration

 def change do
    create table(:airplanes) do
      add :model, :string
      add :year, :string
      add :url, :string
      add :price, :decimal

      timestamps()
    end
  end

end
