# AwesomeTable

## Task:
Show data from awesome elixir page with filter by repository stars count. 

## Steps for application running:
  
  * persistent layer configuration: run scripts from `db/scripts` (it doesn't work for now)
  * for running tests: `./tests.sh`

Useful commands:
  * `mix phx.gen.context Request Request requests`
  * `UPDATE "public".libraries SET updated_at = '2019-10-11 20:04:19', inserted_at = '2019-10-11 20:04:19', request_id = 19
     where request_id = 18`
  * install dependencies with `mix deps.get`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO  
  * tests

  * db dump to project directory
  * db management tutorial to readme file
