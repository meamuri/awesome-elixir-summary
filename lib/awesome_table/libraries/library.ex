defmodule AwesomeTable.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :category, :string
    field :stars, :integer
    field :title, :string
    field :url, :string
    field :owner, :string
    field :request_id, :integer

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:category, :title, :url, :stars, :request_id, :owner])
    |> validate_required([:category, :title, :url, :stars, :owner])
  end
end
