defmodule Exper.Repo.Migrations.Notes do
  use Ecto.Migration

  def change do
	create table "todos" do
	  add :task, :string
		add :description, :text
	  add :priority, :string
	  add :status, :string
		add :category, :string
	  add :datecompleted, :date

	  timestamps()
	end
  end
end
