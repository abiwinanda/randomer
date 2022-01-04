defmodule RandomerWeb.UserControllerTest do
  use RandomerWeb.ConnCase, async: true
  use Mimic
  alias Randomer.Users

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Randomer.Repo, {:shared, self()})
    :ok
  end

  describe "GET /" do
    setup do
      1..5
      |> Enum.to_list()
      |> Enum.each(fn _ -> Users.create_user(%{points: 100}) end)
    end

    test "should return response with users and timestamp field", %{conn: conn} do
      resp =
        conn
        |> get("/")
        |> json_response(200)

      assert %{"users" => _, "timestamp" => _} = resp
    end

    test "should return no more than two users", %{conn: conn} do
      resp =
        conn
        |> get("/")
        |> json_response(200)

      assert %{"users" => users, "timestamp" => _} = resp
      assert Enum.count(users) == 2
    end

    test "should return 503 status code when PointsUpdater GenServers is busy and response with :exit timeout",
         %{conn: conn} do
      Mimic.stub(Randomer.PointsUpdater, :query_users, fn -> {:error, :exit} end)

      resp =
        conn
        |> get("/")
        |> json_response(503)

      assert %{"errors" => %{"detail" => "Server is currently busy. Please retry again later"}} =
               resp
    end

    test "should return 500 status code when PointsUpdater GenServers got unknown error",
         %{conn: conn} do
      Mimic.stub(Randomer.PointsUpdater, :query_users, fn -> {:error, :unknown} end)

      resp =
        conn
        |> get("/")
        |> json_response(500)

      assert %{"errors" => %{"detail" => "Internal Server Error"}} = resp
    end
  end
end
