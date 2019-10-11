# AwesomeTable

Steps for application running:
  * install dependencies with `mix deps.get`
  * persistent layer configuration:
    * create database: `CREATE DATABASE awesome_table_dev;`
    * create db user: `CREATE USER awesome_table_developer WITH password 'awesome_password';`
    * provide access: `GRANT ALL ON DATABASE awesome_table_dev TO awesome_table_developer;`
    * `ALTER USER awesome_table_developer CREATEDB;`

Useful commands:
  * `mix phx.gen.context Request Request requests`
  * `UPDATE "public".libraries SET updated_at = '2019-10-11 20:04:19', inserted_at = '2019-10-11 20:04:19', request_id = 19
     where request_id = 18`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO  
  * tests

  * db dump to project directory
  * db management tutorial to readme file