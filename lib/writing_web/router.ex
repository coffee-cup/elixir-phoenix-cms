defmodule WritingWeb.Router do
  use WritingWeb, :router

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
    pipe_through Writing.AuthAccessPipeline

    get "/", AdminController, :index
    resources "/articles", ArticleController, only: [:index, :create, :edit, :update, :delete]
  end

  scope "/auth", WritingWeb do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", WritingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", AdminController, :login
    get "/logout", AdminController, :logout
    get "/:slug", ArticleControler, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", WritingWeb do
  #   pipe_through :api
  # end
end
