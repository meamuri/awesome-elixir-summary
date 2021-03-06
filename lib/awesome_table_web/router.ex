defmodule AwesomeTableWeb.Router do
  use AwesomeTableWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AwesomeTableWeb do
    pipe_through :browser

    live "/", LiveTable
    get "/legacy", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", AwesomeTableWeb do
    pipe_through :api
  end
end
