defmodule AwesomeTable.Libraries do
  @moduledoc """
  The Libraries context.
  """

  import Ecto.Query, warn: false
  alias AwesomeTable.Repo

  alias AwesomeTable.Libraries.Library

  @doc """
  Returns the list of libraries.

  ## Examples

      iex> list_libraries()
      [%Library{}, ...]

  """
  def list_libraries do
    Repo.all(Library)
  end

  @doc """
  Gets a single library.

  Raises `Ecto.NoResultsError` if the Library does not exist.

  ## Examples

      iex> get_library!(123)
      %Library{}

      iex> get_library!(456)
      ** (Ecto.NoResultsError)

  """
  def get_library!(id), do: Repo.get!(Library, id)

  @doc """
  Creates a library.

  ## Examples

      iex> create_library(%{field: value})
      {:ok, %Library{}}

      iex> create_library(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_library(attrs \\ %{}) do
    %Library{}
    |> Library.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a library.

  ## Examples

      iex> update_library(library, %{field: new_value})
      {:ok, %Library{}}

      iex> update_library(library, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_library(%Library{} = library, attrs) do
    library
    |> Library.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Library.

  ## Examples

      iex> delete_library(library)
      {:ok, %Library{}}

      iex> delete_library(library)
      {:error, %Ecto.Changeset{}}

  """
  def delete_library(%Library{} = library) do
    Repo.delete(library)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking library changes.

  ## Examples

      iex> change_library(library)
      %Ecto.Changeset{source: %Library{}}

  """
  def change_library(%Library{} = library) do
    Library.changeset(library, %{})
  end

  def change_request_id(%Library{} = library, request_id) do
    library
      |> Ecto.Changeset.change(%{request_id: request_id})
      |> AwesomeTable.Repo.update()
  end

  def list_with_stars_filter(min_stars, request_id) do
    (Ecto.Query.from lib in AwesomeTable.Libraries.Library,
                     where: (lib.stars >= ^min_stars or lib.stars < 0) and
                            lib.request_id == ^request_id )
      |> AwesomeTable.Repo.all()
  end

  @doc """
    fetch only libraries with negative count of stars.
  """
  def list_with_stars_filter(request_id) do
    (Ecto.Query.from lib in AwesomeTable.Libraries.Library,
                     where: lib.stars < 0 and lib.request_id == ^request_id )
    |> AwesomeTable.Repo.all()
  end
end
