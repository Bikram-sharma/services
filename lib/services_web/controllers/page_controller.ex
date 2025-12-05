defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller
  alias Services.Servicing
  alias Services.ProviderService

  def home(conn, _params) do
    conn
    |> assign(:ratings, Services.Ratings.list_ratings())
    |> assign(:providers_service, ProviderService.list_providers_service())
    |> assign(:categories, Servicing.list_categories())
    |> render()
  end
end
