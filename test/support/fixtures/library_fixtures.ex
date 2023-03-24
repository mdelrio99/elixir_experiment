defmodule Exper.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exper.Library` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Exper.Library.create_book()

    book
  end
end
