# Randomer

`Randomer` is an OTP app that can return, at max 2, users with a random number of points. `Randomer` only has 1 endpoint which is the root `/` that will return an example data as follows:

```
> curl http://localhost:3000/

{
  "users": [{"id": 1, "points": 30}, {"id": 72, "points": 45}],
  "timestamp": "2020-07-30 17:09:33"
}
```

`Randomer` API is powered by a GenServer called `Randomer.PointsUpdater` that is running in the background when the app starts to update all users points randomly every 1 minute.

`Randomer.PointsUpdater` has two states, `:max_number` and `:timestamp`. The root `/` endpoint will only returns users (limit to 2) that has points greater than `:max_number`. Each time the API in invoked, `:max_number` will be randomly assigned with a new value between `[0, 100]` and `:timestamp` will be updated with current timestamp.

## Project Set Up

For local development purposes, you might want to run the server or unit test locally. You could follow the following guideline to set up and run the project locally.

### Prerequisites

Assuming you already have elixir, phoenix, and docker installed, you could skip prerequisites steps. Otherwise, you could follow the following steps:

1. First you would need to have elixir and phoenix installed in your local machine. You could follow [Installing Elixir](https://elixir-lang.org/install.html) and [Phoenix Installation](https://hexdocs.pm/phoenix/installation.html) guideline to have elixir and phoenix installed respectively. In this project elixir version `1.12.3` and phoenix version `1.5.13` are used.

2. Next, you would also need docker to set up dependency services such as `postgres`. To install docker, it is recommended that you follow the official [Get Docker](https://docs.docker.com/get-docker/) guideline.

### Start the Application

1. Clone this repository into your local computer and cd into the directory.

```sh
git clone <https/ssh-url>
cd randomer
```

2. Run `mix deps.get` to install all the required depencencies.

3. You could start the dependency service, such as postgres, by running `docker-compose up -d`. This will run a postgres container which you could check by running `docker ps`. By default, postgres will run on port `5432`. If you want to change this port, you could change the host port in the docker-compose. If you prefer to use your locally installed postgres, you could skip this step.

4. Rename `.env.example` to `.env`.

5. Run `source .env && ecto.setup` to initialize `Randomer` database. Running `ecto.setup` will also seed the database with one million user records hence it might need a little bit of time to run.

6. Finally you could run the server with iex by running `source .env && iex -S mix phx.server`. By default the server will run on

### Run Unit Test

1. To run the project unit test you could run `source .env && mix ecto.test`.

2. Optinally, you could run `--cover` flag to show the unit test coverage of the project.

## Usage

Once you have the server running you try to access `/` endpoint to see the API in action.

## Contribution

### Pull Request

To contribute to the project, you could fork the repo and open a PR from your fork. Each opened PR, a GitHub action will be executed to run a unit test. If one test is failing, a PR merge will be blocked. Hence, ensure that your changes won't break any existing feature or unit test.

### Issues

If you found any issues with the project, whether it is a bug or you are unable to run the application locally, do not hesitate to post the issues in the Issues tab.
