defmodule AwesomeTable.Model.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [])
    |> validate_required([])
  end
end
