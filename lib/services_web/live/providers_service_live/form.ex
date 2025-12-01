defmodule ServicesWeb.ProvidersServiceLive.Form do
  use ServicesWeb, :live_view

  alias Services.ProviderService
  alias Services.ProviderService.ProvidersService
  alias Services.ServiceProvider
  alias Services.Servicing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage providers_service records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="providers_service-form" phx-change="validate" phx-submit="save">
        <label>{@service_provider.users.username}</label>
        <.input
          field={@form[:service_provider_id]}
          type="text"
          value={@service_provider.id}
          step="any"
          hidden
        />
        <%!-- <.input field={@form[:service_id]} type="text" label="Service" step="any" /> --%>
        <.input
          field={@form[:service_id]}
          type="select"
          prompt="select a service"
          label="service"
          options={@services}
        />
        <.input field={@form[:descriptions]} type="textarea" label="Service Descriptions/Details" rows="10"/>
        <.input field={@form[:custom_price]} type="number" label="Custom price" step="any" />
        <.input field={@form[:is_available]} type="checkbox" checked label="Is available" />

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Providers service</.button>
          <.button><a href="/providers_service">Cancel</a></.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    service_provider =
      ServiceProvider.get_provider_by_user_id(socket.assigns.current_scope.user.id)

    services =
      Servicing.list_services(socket.assigns.current_scope)
      |> Enum.map(fn services ->
        {services.name, services.id}
      end)

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:service_provider, service_provider)
     |> assign(:services, services)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => _id}) do
    providers_service = socket.assigns.current_scope.user.id

    socket
    |> assign(:page_title, "Edit Providers service")
    |> assign(:providers_service, providers_service)
    |> assign(
      :form,
      to_form(
        ProviderService.change_providers_service(socket.assigns.current_scope, providers_service)
      )
    )
  end

  defp apply_action(socket, :new, _params) do
    providers_service = %ProvidersService{}

    socket
    |> assign(:page_title, "New Providers service")
    |> assign(:providers_service, providers_service)
    |> assign(
      :form,
      to_form(
        ProviderService.change_providers_service(socket.assigns.current_scope, providers_service)
      )
    )
  end

  @impl true
  def handle_event("validate", %{"providers_service" => providers_service_params}, socket) do
    changeset =
      ProviderService.change_providers_service(
        socket.assigns.current_scope,
        socket.assigns.providers_service,
        providers_service_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"providers_service" => providers_service_params}, socket) do
    save_providers_service(socket, socket.assigns.live_action, providers_service_params)
  end

  defp save_providers_service(socket, :edit, providers_service_params) do
    case ProviderService.update_providers_service(
           socket.assigns.current_scope,
           socket.assigns.providers_service,
           providers_service_params
         ) do
      {:ok, providers_service} ->
        {:noreply,
         socket
         |> put_flash(:info, "Providers service updated successfully")
         |> push_navigate(
           to:
             return_path(
               socket.assigns.current_scope,
               socket.assigns.return_to,
               providers_service
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_providers_service(socket, :new, providers_service_params) do
    case ProviderService.create_providers_service(
           socket.assigns.current_scope,
           providers_service_params
         ) do
      {:ok, providers_service} ->
        {:noreply,
         socket
         |> put_flash(:info, "Providers service created successfully")
         |> push_navigate(
           to:
             return_path(
               socket.assigns.current_scope,
               socket.assigns.return_to,
               providers_service
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _providers_service), do: ~p"/providers_service"

  defp return_path(_scope, "show", providers_service),
    do: ~p"/providers_service/#{providers_service}"
end
