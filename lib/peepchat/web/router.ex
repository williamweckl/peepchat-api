defmodule Peepchat.Web.Router do
  use Peepchat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Peepchat.Web do
    pipe_through :api
    # Registration
    post "/register", RegistrationController, :create
    # Login
    post "/token", SessionController, :create, as: :login
  end

  scope "/api", Peepchat.Web do
    pipe_through :api_auth
    get "/user/current", UserController, :current
    resources "/user", UserController, only: [:show, :index] do
      get "/rooms", RoomController, :index, as: :rooms
    end
    resources "/rooms", RoomController, except: [:new, :edit]
  end
end
