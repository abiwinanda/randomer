defmodule RandomerWeb.UserView do
  use RandomerWeb, :view
  alias RandomerWeb.UserView

  def render("index.json", %{user: data}) do
    %{
      users: render_many(data.users, UserView, "user.json"),
      timestamp: convert_timestamp(data.timestamp)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      points: user.points
    }
  end

  defp convert_timestamp(nil), do: nil

  defp convert_timestamp(timestamp),
    do: timestamp |> DateTime.to_string() |> String.replace("Z", "")
end
