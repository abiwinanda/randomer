defmodule Randomer.PointsUpdater do
  @moduledoc """
  A GenServer that updates all users points with random number every 1 minute. This GenServer
  has two states: `:max_number` and `:timestamp`. `:max_number` will get updated every minute
  after all users points have been updated and `:timestamp` will get updated after users are
  queries using `query_user/0`.
  """
  use GenServer
  require Logger
  alias Randomer.Users
  alias Randomer.PointsUpdater

  defstruct [:max_number, :timestamp]

  @doc """
  Start Randomer.PointsUpdater GenServer

  ## Examples

      iex> start_link(:anything)
      {:ok, #PID<0.xxx.0>}

  """
  def start_link(args) do
    GenServer.start(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    initial_state = %PointsUpdater{max_number: Enum.random(0..100)}

    {:ok, initial_state, {:continue, :loop}}
  end

  @impl true
  def handle_continue(:loop, state) do
    Process.send_after(self(), :update_points, 60_000)

    {:noreply, state}
  end

  # :update_points handle_info callback will be run every minute to update
  # all users points and :max_number state of the PointsUpdater GenServer
  @impl true
  def handle_info(:update_points, state) do
    Logger.debug("Updating all users points")
    Task.start_link(fn -> Users.update_all_users_points_randomly() end)

    {:noreply, %PointsUpdater{state | max_number: Enum.random(0..100)}, {:continue, :loop}}
  end

  @doc """
  Return at max 2 users with more point than :max_number and update the genserver state
  :timestamp with the current timestamp

  ## Examples

      iex> query_user()
      %{
        timestamp: ~U[2022-01-04 10:35:38.970826Z],
        users: [
          %Randomer.Users.User{
            __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
            id: 5021904,
            inserted_at: ~U[2022-01-04 10:14:57Z],
            points: 99,
            updated_at: ~U[2022-01-04 10:35:06Z]
          },
          %Randomer.Users.User{
            __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
            id: 5548634,
            inserted_at: ~U[2022-01-04 10:15:22Z],
            points: 99,
            updated_at: ~U[2022-01-04 10:35:06Z]
          }
        ]
      }
  """
  def query_users(retry \\ 2)

  def query_users(retry) when retry > 0 do
    try do
      {:ok, GenServer.call(__MODULE__, :query_user)}
    catch
      # When the the GenServer is busy, it might not be able to respond in time
      # hence :exit error will be returned and retry will be performed
      :exit, _ ->
        Logger.debug("Fail to query users. Retrying...")
        query_users(retry - 1)

      e ->
        Logger.error("Fail to query users: #{e}")
        {:error, :error}
    end
  end

  def query_users(0) do
    try do
      {:ok, GenServer.call(__MODULE__, :query_user)}
    catch
      :exit, _ ->
        Logger.error("Fail to query users: :timeout")
        {:error, :exit}

      e ->
        Logger.error("Fail to query users: #{e}")
        {:error, :error}
    end
  end

  @impl true
  def handle_call(:query_user, _from, state) do
    output = %{
      users: Users.get_two_users_with_points_greater_than(state.max_number),
      timestamp: state.timestamp
    }

    {:reply, output,
     %PointsUpdater{state | timestamp: DateTime.truncate(DateTime.utc_now(), :second)}}
  end
end
