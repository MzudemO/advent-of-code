defmodule AocWeb.Router do
  use AocWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AocWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AocWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # TODO: Proper Navigation
  scope "/2020", AocWeb do
    pipe_through :browser

    live "/1", Year2020.Day1Live
    live "/2", Year2020.Day2Live
    live "/3", Year2020.Day3Live
    live "/4", Year2020.Day4Live
    live "/5", Year2020.Day5Live
  end
  
  scope "/2021", AocWeb do
    pipe_through :browser
    
    live "/1", Year2021.Day1Live
    live "/2", Year2021.Day2Live
    live "/3", Year2021.Day3Live
    live "/4", Year2021.Day4Live
    live "/5", Year2021.Day5Live
    live "/6", Year2021.Day6Live
    live "/7", Year2021.Day7Live
    live "/8", Year2021.Day8Live
    live "/9", Year2021.Day9Live
    live "/10", Year2021.Day10Live
    live "/11", Year2021.Day11Live
    live "/13", Year2021.Day13Live
  end

  # Other scopes may use custom stacks.
  # scope "/api", AocWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AocWeb.Telemetry
    end
  end
end
