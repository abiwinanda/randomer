defmodule Randomer.PointsUpdaterTest do
  use Randomer.DataCase

  alias Randomer.Users
  alias Randomer.PointsUpdater

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Randomer.Repo, {:shared, self()})
    :ok
  end

  describe "PointsUpdater" do
    setup do
      PointsUpdater.start_link(:any)

      1..5
      |> Enum.to_list()
      |> Enum.each(fn _ -> Users.create_user(%{points: 100}) end)
    end

    test "query_users/2 should return timestamps and at max 2 users" do
      {:ok, output} = PointsUpdater.query_users()

      assert %{timestamp: _, users: users} = output
      assert Enum.count(users) == 2
    end
  end
end
