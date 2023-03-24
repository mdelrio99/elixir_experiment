defmodule ExperWeb.Router do
  use ExperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExperWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExperWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/export_todos", ExportController, :create


    live "/main", MainLive.MainIndex, :index

    live "/anim", AnimLive.AnimIndex, :index

    live "/books", BookLive.BookIndex, :index
    live "/books/new", BookLive.BookIndex, :new
    live "/books/:id/edit", BookLive.BookIndex, :edit

    live "/books/:id", BookLive.Show, :show
    live "/books/:id/show/edit", BookLive.Show, :edit

    live "/airplanes", AirplaneLive.AirplaneIndex, :index
    live "/airplanes/new", AirplaneLive.AirplaneIndex, :new
    live "/airplanes/:id/edit", AirplaneLive.AirplaneIndex, :edit

    live "/airplanes/:id", AirplaneLive.Show, :show
    live "/airplanes/:id/show/edit", AirplaneLive.Show, :edit
    live "/airplanes/:id/show/view", AirplaneLive.Show, :view


    live "/todos", TodoLive.TodoIndex, :index
    live "/todos/new", TodoLive.TodoIndex, :new
    live "/todos/:id/edit", TodoLive.TodoIndex, :edit

    live "/todos/:id", TodoLive.Show, :show
    live "/todos/:id/show/edit", TodoLive.Show, :edit

    live "/datatable", DataTableLive.DatatableIndex, :main
    live "/datatable/new", DataTableLive.DatatableIndex, :new
    live "/datatable/:id/edit", DataTableLive.DatatableIndex, :edit

    live "/ftest", FtestLive.Index, :index
  end


  scope "/api", ExperWeb do
    pipe_through :api

    resources "/books", BookController, except: [:new, :edit]
    resources "/todos", TodoController, except: [:new, :edit]
    resources "/todos/:id", TodoController, except: [:new, :edit]
  end


  # Other scopes may use custom stacks.
  # scope "/api", ExperWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:exper, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExperWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
