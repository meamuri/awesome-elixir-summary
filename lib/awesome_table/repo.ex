defmodule AwesomeTable.Repo do
  use Ecto.Repo,
    otp_app: :awesome_table,
    adapter: Ecto.Adapters.Postgres
end
