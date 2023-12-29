defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  pipeline :auth do
    plug TodolistWeb.JwtAuthPlug
  end

  scope "/api/auth", TodolistWeb do
    pipe_through :auth
    get "/", AuthController, :get
    post "/users/sign_in", AuthController, :register

    resources "/users", UserController, except: [:new, :edit]

    get "/workingtimes", WorkingtimeController, :index_all
    # http://localhost:4000/api/workingtimes/1?start=XXX&end=YYY
    get "/workingtimes/:user_id2", WorkingtimeController, :index1
    get "/workingtimes/:user_id2", WorkingtimeController, :index
    get "/workingtimes/:user_id2", WorkingtimeController, :show
    get "/workingtimes/:user_id2/:id", WorkingtimeController, :show1
    post "/workingtimes/:user_id2", WorkingtimeController, :create
    put "/workingtimes/:user_id2", WorkingtimeController, :create

    resources "/workingtimes", WorkingtimeController, only: [:delete]

    get "/clocks/:user_id", ClockController, :index
    get "/clocks/:user_id", ClockController, :show
    post "/clocks/:user_id", ClockController, :create
    delete "/clocks/:id", ClockController, :delete
  end

  scope "/users", TodolistWeb do
    pipe_through :api

    post "/sign_up", AuthController, :login
    post "/sign_out", AuthController, :logout
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TodolistWeb.Telemetry
    end
  end
end
