defmodule ServicesWeb.Router do
  use ServicesWeb, :router

  import ServicesWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, html: {ServicesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
    plug ServicesWeb.Plugs
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServicesWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/services", DashController, :list_services
    # get "/services/:id/book", DashController, :book
  end

  # Other scopes may use custom stacks.
  # scope "/api", ServicesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:services, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ServicesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ServicesWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
    on_mount: [{ServicesWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/service_providers", ProviderLive.Index, :index
      live "/service_providers/new", ProviderLive.Form, :new
      live "/service_providers/:id", ProviderLive.Show, :show
      live "/service_providers/:id/edit", ProviderLive.Form, :edit

      live "/providers_service", ProvidersServiceLive.Index, :index
      live "/providers_service/new", ProvidersServiceLive.Form, :new
      live "/providers_service/:id", ProvidersServiceLive.Show, :show
      live "/providers_service/:id/edit", ProvidersServiceLive.Form, :edit

      live "/bookings", BookingLive.Index, :index
      live "/bookings/new", BookingLive.Form, :new
      live "/bookings/:id", BookingLive.Show, :show
      live "/services/:id/book", BookingLive.Form, :form
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", ServicesWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{ServicesWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
    delete "/users/deactivate", UserSessionController, :log_out_deactivated
  end

  scope "/", ServicesWeb do
    pipe_through [:browser, :require_admin_or_super_admin_authentication]

    live_session :require_admin_or_super_admin_authentication,
      on_mount: [{ServicesWeb.UserAuth, :require_admin_or_super_admin_authentication}] do
      live "/manage", UserLive.Manage, :manage
      live "/manage/:user_id/edit", UserLive.Edit, :edit

      live "/manage/categories", CategoryLive.Index, :index
      live "/manage/categories/new", CategoryLive.Form, :new
      live "/manage/categories/:id", CategoryLive.Show, :show
      live "/manage/categories/:id/edit", CategoryLive.Form, :edit

      live "/manage/services", ServiceLive.Index, :index
      live "/manage/services/new", ServiceLive.Form, :new
      live "/manage/services/:id", ServiceLive.Show, :show
      live "/manage/services/:id/edit", ServiceLive.Form, :edit
    end
  end
end
