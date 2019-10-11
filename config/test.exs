use Mix.Config

# Configure your database
config :awesome_table, AwesomeTable.Repo,
  username: System.get_env("DB_USER_NAME"),
  password: System.get_env("DB_USER_PASS"),
  database: "awesome_table_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :awesome_table,
       github_token: System.get_env("GITHUB_TOKEN")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :awesome_table, AwesomeTableWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
