defmodule ServicesWeb.ProviderLive.Show do
  use ServicesWeb, :live_view

  alias Services.ServiceProvider

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Provider {@provider.id}
        <:subtitle>This is a provider record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/service_providers"} variant="blue-gray">
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="dark-blue-gray"
            navigate={~p"/service_providers/#{@provider}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit provider
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Bio">{@provider.bio}</:item>
        <:item title="Years of experience">{@provider.years_of_experience}</:item>
        <:item title="Is verified">{@provider.is_verified}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      ServiceProvider.subscribe_service_providers(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Provider")
     |> assign(:provider, ServiceProvider.get_provider!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Services.ServiceProvider.Provider{id: id} = provider},
        %{assigns: %{provider: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :provider, provider)}
  end

  def handle_info(
        {:deleted, %Services.ServiceProvider.Provider{id: id}},
        %{assigns: %{provider: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current provider was deleted.")
     |> push_navigate(to: ~p"/service_providers")}
  end

  def handle_info({type, %Services.ServiceProvider.Provider{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
