defmodule ServicesWeb.DashController do
  use ServicesWeb, :controller
  alias Services.Servicing
  alias Services.ProviderService

  def list_services(conn, params) do
    is_hidden = Servicing.is_hidden(conn.assigns.current_scope)
    categories = Servicing.list_categories()

    # pagination
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = 12

    # handle category
    selected_category =
      case params["category_id"] do
        "" -> nil
        nil -> nil
        cat -> cat
      end

    # fetch services
    providers_service =
      case selected_category do
        nil -> ProviderService.list_providers_service()
        category_id -> ProviderService.list_providers_service_by_category(category_id)
      end

    total_count = length(providers_service)

    paginated_services =
      providers_service
      |> Enum.slice((page - 1) * per_page, per_page)

    conn
    |> assign(:providers_service, paginated_services)
    |> assign(:selected_category, selected_category)
    |> assign(:page, page)
    |> assign(:per_page, per_page)
    |> assign(:total_count, total_count)
    |> render(:list_services, is_hidden: is_hidden, categories: categories)
  end
end
