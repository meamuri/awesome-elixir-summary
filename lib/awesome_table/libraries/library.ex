defmodule AwesomeTable.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :category, :string
    field :stars, :integer
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:category, :title, :url, :stars])
    |> validate_required([:category, :title, :url, :stars])
  end
end
