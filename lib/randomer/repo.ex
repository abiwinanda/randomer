defmodule Randomer.Repo do
  use Ecto.Repo,
    otp_app: :randomer,
    adapter: Ecto.Adapters.Postgres
end
