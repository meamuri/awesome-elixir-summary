defmodule AwesomeTable.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :title, :string
      add :url, :string
      add :category, :string
      add :stars, :integer

      timestamps()
    end

  end
end
