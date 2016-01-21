defmodule ElixirFriends.Router do
  use ElixirFriends.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirFriends do
    pipe_through :api

    resources "/posts", API.PostController, only: [:index]
  end

  scope "/", ElixirFriends do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/posts", PostController
  end
end
