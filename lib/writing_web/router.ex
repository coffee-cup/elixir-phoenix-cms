defmodule WritingWeb.Router do
  use WritingWeb, :router

  alias WritingWeb.Plugs

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

  pipeline :check_admin do
    plug Plugs.IsAdmin
  end

  scope "/admin", WritingWeb do
    pipe_through [:browser, Plugs.AuthAccessPipeline, :check_admin]

    get "/", AdminController, :index
    resources "/articles", ArticleController, only: [:index, :new, :create, :edit, :update, :delete]
  end

  scope "/auth", WritingWeb do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", WritingWeb do
    pipe_through [:browser, :check_admin]

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
