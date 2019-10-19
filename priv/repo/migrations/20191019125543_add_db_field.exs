defmodule AwesomeTable.Repo.Migrations.AddDbField do
  use Ecto.Migration

  def change do
    alter table("libraries") do
      add :owner, :string, default: ""
    end
  end
end
