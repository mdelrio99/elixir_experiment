defmodule Exper.Repo.Migrations.MoreFields do
  use Ecto.Migration

  def change do
	rename table("books"), :name, to: :title

	alter table("books") do
      		add :author,      :string
      		add :ISBN,       :string
      		add :price,       :decimal

    	end
  end
end
