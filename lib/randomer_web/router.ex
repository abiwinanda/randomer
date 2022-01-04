defmodule RandomerWeb.Router do
  use RandomerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RandomerWeb do
    pipe_through :api

    get "/", UserController, :index
  end
end
