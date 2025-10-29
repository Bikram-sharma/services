defmodule ServicesWeb.ServiceLive.Form do
  use ServicesWeb, :live_view

  alias Services.Servicing
  alias Services.Servicing.Service

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage service records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="service-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
        field={@form[:category_id]}
        type="select"
        prompt="select a category"
        label="category"
        options={@categories}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Service</.button>
          <.button navigate={return_path(@current_scope, @return_to, @service)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    categories =
      Servicing.list_categories(socket.assigns.current_scope)
      |>Enum.map(fn category ->
        {category.name, category.id}

      end)

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)
     |> assign(:categories, categories)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    service = Servicing.get_service!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Service")
    |> assign(:service, service)
    |> assign(:form, to_form(Servicing.change_service(socket.assigns.current_scope, service)))
  end

  defp apply_action(socket, :new, _params) do
    service = %Service{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Service")
    |> assign(:service, service)
    |> assign(:form, to_form(Servicing.change_service(socket.assigns.current_scope, service)))
  end

  @impl true
  def handle_event("validate", %{"service" => service_params}, socket) do
    changeset = Servicing.change_service(socket.assigns.current_scope, socket.assigns.service, service_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"service" => service_params}, socket) do
    save_service(socket, socket.assigns.live_action, service_params)
  end

  defp save_service(socket, :edit, service_params) do
    case Servicing.update_service(socket.assigns.current_scope, socket.assigns.service, service_params) do
      {:ok, service} ->
        {:noreply,
         socket
         |> put_flash(:info, "Service updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, service)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_service(socket, :new, service_params) do
    case Servicing.create_service(socket.assigns.current_scope, service_params) do
      {:ok, service} ->
        {:noreply,
         socket
         |> put_flash(:info, "Service created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, service)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _service), do: ~p"/services"
  defp return_path(_scope, "show", service), do: ~p"/services/#{service}"
end
