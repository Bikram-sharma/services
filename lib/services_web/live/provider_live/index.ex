defmodule ServicesWeb.ProviderLive.Index do
  use ServicesWeb, :live_view

  alias Services.Service_provider

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Provider
        <:actions>
          <.button variant="primary" navigate={~p"/provider/new"}>
            <.icon name="hero-plus" /> New Provider
          </.button>
        </:actions>
      </.header>

      <.table
        id="provider"
        rows={@streams.provider_collection}
        row_click={fn {_id, provider} -> JS.navigate(~p"/provider/#{provider}") end}
      >
        <:col :let={{_id, provider}} label="Bio">{provider.bio}</:col>
        <:col :let={{_id, provider}} label="Experience year">{provider.experience_year}</:col>
        <:col :let={{_id, provider}} label="Is verified">{provider.is_verified}</:col>
        <:action :let={{_id, provider}}>
          <div class="sr-only">
            <.link navigate={~p"/provider/#{provider}"}>Show</.link>
          </div>
          <.link navigate={~p"/provider/#{provider}/edit"}>Edit</.link>
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
      Service_provider.subscribe_provider(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Provider")
     |> stream(:provider_collection, list_provider(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    provider = Service_provider.get_provider!(socket.assigns.current_scope, id)
    {:ok, _} = Service_provider.delete_provider(socket.assigns.current_scope, provider)

    {:noreply, stream_delete(socket, :provider_collection, provider)}
  end

  @impl true
  def handle_info({type, %Services.Service_provider.Provider{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :provider_collection, list_provider(socket.assigns.current_scope), reset: true)}
  end

  defp list_provider(current_scope) do
    Service_provider.list_provider(current_scope)
  end
end
