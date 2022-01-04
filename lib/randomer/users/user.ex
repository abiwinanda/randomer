defmodule Randomer.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :points, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:points])
    |> validate_required([:points])
    |> validate_range(:points, 0, 100)
  end

  defp validate_range(changeset, field, lower, upper) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        value >= lower && value <= upper -> []
        true -> [{field, "must be between 0 and 100 inclusive"}]
      end
    end)
  end
end
