defmodule ServicesWeb.ServiceLive.Show do
  use ServicesWeb, :live_view

  alias Services.Servicing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Service {@service.id}
        <:subtitle>This is a service record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/manage/services"} variant="blue-gray">
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="dark-blue-gray" navigate={~p"/manage/services/#{@service}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit service
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@service.name}</:item>
        <:item title="Description">{@service.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Servicing.subscribe_services(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Service")
     |> assign(:service, Servicing.get_service(id))}
  end

  @impl true
  def handle_info(
        {:updated, %Services.Servicing.Service{id: id} = service},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :service, service)}
  end

  def handle_info(
        {:deleted, %Services.Servicing.Service{id: id}},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current service was deleted.")
     |> push_navigate(to: ~p"/manage/services")}
  end

  def handle_info({type, %Services.Servicing.Service{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
