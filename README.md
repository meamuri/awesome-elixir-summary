# AwesomeTable

Steps for application running:
  * install dependencies with `mix deps.get`
  * persistent layer configuration:
    * create database: `CREATE DATABASE awesome_table_dev;`
    * create db user: `CREATE USER awesome_table_developer WITH password 'awesome_password';`
    * provide access: `GRANT ALL ON DATABASE awesome_table_dev TO awesome_table_developer;`
    * `ALTER USER awesome_table_developer CREATEDB;`

Useful commands:
  * mix phx.gen.context Request Request requests

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO
  * date validation
  * sort  
  * tests
  * categories
  * codestyle: module Model to Request module, more functions and helpers
