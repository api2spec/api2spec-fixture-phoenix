defmodule Api2specFixturePhoenix.Router do
  use Phoenix.Router
  import Plug.Conn

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Api2specFixturePhoenix do
    pipe_through :api

    get "/health", HealthController, :index
    get "/health/ready", HealthController, :ready

    resources "/users", UserController, only: [:index, :show, :create, :update, :delete] do
      get "/posts", PostController, :user_posts
    end

    get "/posts", PostController, :index
    get "/posts/:id", PostController, :show
    post "/posts", PostController, :create
  end
end
