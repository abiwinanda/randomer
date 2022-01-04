defmodule Randomer.UsersTest do
  use Randomer.DataCase

  alias Randomer.Users

  describe "users" do
    alias Randomer.Users.User

    @valid_attrs %{points: 42}
    @update_attrs %{points: 43}
    @invalid_attrs %{points: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "get_two_users_with_points_greater_than/1 should return at max two users" do
      assert Enum.count(Users.get_two_users_with_points_greater_than(50)) == 0

      assert {:ok, _} = Users.create_user(%{points: 80})
      assert Enum.count(Users.get_two_users_with_points_greater_than(50)) == 1

      assert {:ok, _} = Users.create_user(%{points: 90})
      assert Enum.count(Users.get_two_users_with_points_greater_than(50)) == 2

      assert {:ok, _} = Users.create_user(%{points: 95})
      assert Enum.count(Users.get_two_users_with_points_greater_than(50)) == 2
    end

    test "get_two_users_with_points_greater_than/1 should only return users that has points greater than the input value" do
      assert {:ok, _} = Users.create_user(%{points: 50})
      assert {:ok, _} = Users.create_user(%{points: 60})
      assert {:ok, _} = Users.create_user(%{points: 70})

      assert Enum.count(Users.get_two_users_with_points_greater_than(60)) == 1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.points == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "create_user/1 with points outside [0, 100] returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(%{points: 150})
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.points == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "update_all_users_points_randomly/0 should update all users point" do
      assert {:ok, _} = Users.create_user(%{points: 50})
      assert {:ok, _} = Users.create_user(%{points: 50})
      assert {:ok, _} = Users.create_user(%{points: 50})

      assert {3, _} = Users.update_all_users_points_randomly()
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
