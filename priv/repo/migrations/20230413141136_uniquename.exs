defmodule Exper.Repo.Migrations.Uniquename do
  use Ecto.Migration

  def change do
	create(
	   unique_index(
		:airplanes,
		 ~w(model)a,
		 name: :index_for_models_duplicate_entries
	   )
	)
	create(
	   unique_index(
		:todos,
		 ~w(task)a,
		 name: :index_for_todos_duplicate_entries
	   )
	)
  end
end
