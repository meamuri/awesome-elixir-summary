defmodule AwesomeTable.LibrariesTest do
  use AwesomeTable.DataCase

  alias AwesomeTable.Libraries

  describe "libraries" do
    alias AwesomeTable.Libraries.Library

    @valid_attrs %{category: "some category", stars: 42, title: "some title", url: "some url"}
    @update_attrs %{category: "some updated category", stars: 43, title: "some updated title", url: "some updated url"}
    @invalid_attrs %{category: nil, stars: nil, title: nil, url: nil}

    def library_fixture(attrs \\ %{}) do
      {:ok, library} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Libraries.create_library()

      library
    end

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Libraries.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Libraries.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      assert {:ok, %Library{} = library} = Libraries.create_library(@valid_attrs)
      assert library.category == "some category"
      assert library.stars == 42
      assert library.title == "some title"
      assert library.url == "some url"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Libraries.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      assert {:ok, %Library{} = library} = Libraries.update_library(library, @update_attrs)
      assert library.category == "some updated category"
      assert library.stars == 43
      assert library.title == "some updated title"
      assert library.url == "some updated url"
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = Libraries.update_library(library, @invalid_attrs)
      assert library == Libraries.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = Libraries.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> Libraries.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = Libraries.change_library(library)
    end
  end
end
