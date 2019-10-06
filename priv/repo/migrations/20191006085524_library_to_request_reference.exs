defmodule AwesomeTable.Repo.Migrations.LibraryToRequestReference do
  use Ecto.Migration

  def change do
    alter table(:libraries) do
      add :request_id, references(:requests)
    end
  end
end
