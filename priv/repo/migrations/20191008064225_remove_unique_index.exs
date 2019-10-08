defmodule AwesomeTable.Repo.Migrations.RemoveUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:libraries, [:url])
  end
end
