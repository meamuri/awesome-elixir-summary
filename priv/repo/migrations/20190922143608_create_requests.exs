defmodule AwesomeTable.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do

      timestamps()
    end

  end
end
