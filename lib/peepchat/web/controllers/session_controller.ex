defmodule Peepchat.Web.SessionController do
  use Peepchat.Web, :controller

  import Comeonin.Bcrypt
  require Logger

  alias Peepchat.User

  def create(conn, %{"grant_type" => "password",
    "username" => username,
    "password" => password}) do

    try do
      # Attempt to retrieve exactly one user from the DB, whose
      #   email matches the one provided with the login request
      user = User
      |> where(email: ^username)
      |> Repo.one!

      case checkpw(password, user.password_hash) do
        true ->
          # Successful login
          Logger.info "User " <> username <> " just logged in"
          # Encode a JWT
          { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt}) # Return token to the client
        false ->
          # Unsuccessful login
          Logger.warn "User " <> username <> " just failed to login"
          conn
          |> put_status(401)
          |> render(ErrorView, "401.json") # 401
      end
    rescue
      e ->
        IO.inspect e # Print error to the console for debugging
        Logger.error "Unexpected error while attempting to login user " <> username
        conn
        |> put_status(401)
        |> render(ErrorView, "401.json") # 401
    end
  end

  def create(_conn, %{"grant_type" => _}) do
  	## Handle unknown grant type
  	throw "Unsupported grant_type"
  end
end
