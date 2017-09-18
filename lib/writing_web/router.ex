defmodule WritingWeb.Router do
  use WritingWeb, :router

  alias Writing.Plugs

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

  scope "/admin", WritingWeb do
    pipe_through :browser
    pipe_through Plugs.AuthAccessPipeline
    pipe_through Plugs.IsAdmin

    get "/", AdminController, :index
    resources "/articles", ArticleController, only: [:index, :new, :create, :edit, :update, :delete]
  end

  scope "/auth", WritingWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", WritingWeb do
    pipe_through :browser
    pipe_through Plugs.IsAdmin

    get "/", PageController, :index
    get "/login", AdminController, :login
    get "/logout", AdminController, :logout
    get "/:slug", ArticleController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", WritingWeb do
  #   pipe_through :api
  # end
end
