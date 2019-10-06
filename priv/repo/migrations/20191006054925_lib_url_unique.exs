defmodule AwesomeTable.Repo.Migrations.LibUrlUnique do
  use Ecto.Migration

  def change do
    create unique_index(:libraries, [:url])
  end
end
