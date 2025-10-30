defmodule ServicesWeb.ProvidersServiceLive.Show do
  use ServicesWeb, :live_view

  alias Services.ProviderService

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Providers service {@providers_service.id}
        <:subtitle>This is a providers_service record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/providers_service"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/providers_service/#{@providers_service}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit providers_service
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Custom price">{@providers_service.custom_price}</:item>
        <:item title="Is available">{@providers_service.is_available}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      ProviderService.subscribe_providers_service(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Providers service")
     |> assign(:providers_service, ProviderService.get_providers_service!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Services.ProviderService.ProvidersService{id: id} = providers_service},
        %{assigns: %{providers_service: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :providers_service, providers_service)}
  end

  def handle_info(
        {:deleted, %Services.ProviderService.ProvidersService{id: id}},
        %{assigns: %{providers_service: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current providers_service was deleted.")
     |> push_navigate(to: ~p"/providers_service")}
  end

  def handle_info({type, %Services.ProviderService.ProvidersService{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
