defmodule RandomerWeb.UserController do
  use RandomerWeb, :controller

  alias Randomer.PointsUpdater

  def index(conn, _params) do
    case PointsUpdater.query_users() do
      {:ok, users} ->
        conn
        |> put_status(200)
        |> render("index.json", user: users)

      {:error, :exit} ->
        conn
        |> put_status(503)
        |> put_view(RandomerWeb.ErrorView)
        |> render("503.json")

      {:error, _} ->
        conn
        |> put_status(500)
        |> put_view(RandomerWeb.ErrorView)
        |> render("500.json")
    end
  end
end
