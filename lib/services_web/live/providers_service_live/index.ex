defmodule ServicesWeb.ProvidersServiceLive.Index do
  use ServicesWeb, :live_view

  alias Services.ProviderService

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Providers service
        <:actions>
          <.button variant="dark-blue-gray" navigate={~p"/providers_service/new"}>
            <.icon name="hero-plus" /> New Providers service
          </.button>
        </:actions>
      </.header>

      <.table
        id="providers_service"
        rows={@streams.providers_service_collection}
        row_click={fn {_id, providers_service} -> JS.navigate(~p"/providers_service/#{providers_service}") end}
      >
        <:col :let={{_id, providers_service}} label="Service">{providers_service.services.name}</:col>
        <:col :let={{_id, providers_service}} label="Custom price">{providers_service.custom_price}</:col>
        <:col :let={{_id, providers_service}} label="Is available">{providers_service.is_available}</:col>
        <:action :let={{_id, providers_service}}>
          <div class="sr-only">
            <.link navigate={~p"/providers_service/#{providers_service}"}>Show</.link>
          </div>
          <.link navigate={~p"/providers_service/#{providers_service}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, providers_service}}>
          <.link
            phx-click={JS.push("delete", value: %{id: providers_service.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      ProviderService.subscribe_providers_service(socket.assigns.current_scope)
    end
    is_hidden = Services.Servicing.is_hidden(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:is_hidden, is_hidden)
     |> assign(:page_title, "Listing Providers service")
     |> stream(:providers_service_collection, list_providers_service(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    providers_service = ProviderService.get_providers_service!(socket.assigns.current_scope, id)
    {:ok, _} = ProviderService.delete_providers_service(socket.assigns.current_scope, providers_service)

    {:noreply, stream_delete(socket, :providers_service_collection, providers_service)}
  end

  @impl true
  def handle_info({type, %Services.ProviderService.ProvidersService{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :providers_service_collection, list_providers_service(socket.assigns.current_scope), reset: true)}
  end

  defp list_providers_service(current_scope) do
    ProviderService.list_providers_service(current_scope)
  end
end
