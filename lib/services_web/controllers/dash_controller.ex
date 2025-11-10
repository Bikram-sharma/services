defmodule ServicesWeb.DashController do
  use ServicesWeb, :controller
  alias Services.Servicing
  alias Services.ProviderService

  def dash(conn, params) do

    is_hidden = Servicing.is_hidden(conn.assigns.current_scope)

     categories = Servicing.list_categories()
    providers_service = case params["category_id"] do
      nil ->
        ProviderService.list_providers_service()
      category_id ->
        ProviderService.list_providers_service_by_category(category_id)
    end
    conn
    |> assign(:providers_service, providers_service)
    |> assign(:selected_category, params["category_id"] || "")
    |> render(:dash, is_hidden: is_hidden, categories: categories)
  end
end
