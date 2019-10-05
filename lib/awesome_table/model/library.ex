defmodule AwesomeTable.Model.Library do
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
    |> cast(attrs, [:title, :url, :category, :stars])
    |> validate_required([:title, :url, :category, :stars])
  end
end
