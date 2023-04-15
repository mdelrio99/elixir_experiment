defmodule Exper.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Exper.Repo

  alias Exper.Library.Book
  alias Exper.Library.Airplane
  alias Exper.Library.Todo

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  def list_airplanes do
    Repo.all(Airplane)
  end

  def list_todos do
    Repo.all(Todo)
  end

  def search_todos(search_term) do
    search_term = "%#{search_term}%"

    query =
      from(
        todo in Todo,
        where: ilike(todo.task, ^search_term)
      )

    Repo.all(query)
  end


  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)
  def get_airplane!(id), do: Repo.get!(Airplane, id)
  def get_airplane(id), do: Repo.get(Airplane, id)
  def get_todo!(id), do: Repo.get!(Todo, id)
  def get_todo(id), do: Repo.get(Todo, id)


  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def create_airplane(attrs \\ %{}) do
    %Airplane{}
    |> Airplane.changeset(attrs)
    |> Repo.insert()
  end

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  defp showit(s) do
    IO.inspect("@@@@@@@@@@@@")
    IO.inspect(s)
end

  def sim_create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> showit()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def update_airplane(%Airplane{} = airplane, attrs) do
    airplane
    |> Airplane.changeset(attrs)
    |> Repo.update()
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def delete_airplane(%Airplane{} = airplane) do
    Repo.delete(airplane)
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def change_airplane(%Airplane{} = airplane, attrs \\ %{}) do
    Airplane.changeset(airplane, attrs)
  end

  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
