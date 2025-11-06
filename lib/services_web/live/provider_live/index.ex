defmodule ServicesWeb.ProviderLive.Index do
  use ServicesWeb, :live_view

  alias Services.ServiceProvider

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Service providers
        <:actions>
          <.button variant="dark-blue-gray" navigate={~p"/service_providers/new"}>
            <.icon name="hero-plus" /> New Provider
          </.button>
        </:actions>
      </.header>

      <.table
        id="service_providers"
        rows={@streams.service_providers}
        row_click={fn {_id, provider} -> JS.navigate(~p"/service_providers/#{provider}") end}
      >
        <:col :let={{_id, provider}} label="Bio">{provider.bio}</:col>
        <:col :let={{_id, provider}} label="Years of experience">{provider.years_of_experience}</:col>
        <:col :let={{_id, provider}} label="Is verified">{provider.is_verified}</:col>
        <:action :let={{_id, provider}}>
          <div class="sr-only">
            <.link navigate={~p"/service_providers/#{provider}"}>Show</.link>
          </div>
          <.link navigate={~p"/service_providers/#{provider}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, provider}}>
          <.link
            phx-click={JS.push("delete", value: %{id: provider.id}) |> hide("##{id}")}
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
      ServiceProvider.subscribe_service_providers(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:prefix, "listing service_providers")
     |> stream(:service_providers, list_service_providers(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    provider = ServiceProvider.get_provider!(socket.assigns.current_scope, id)
    {:ok, _} = ServiceProvider.delete_provider(socket.assigns.current_scope, provider)

    {:noreply, stream_delete(socket, :service_providers, provider)}
  end

  @impl true
  def handle_info({type, %Services.ServiceProvider.Provider{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :service_providers, list_service_providers(socket.assigns.current_scope), reset: true)}
  end

  defp list_service_providers(current_scope) do
    ServiceProvider.list_service_providers(current_scope)
  end
end
