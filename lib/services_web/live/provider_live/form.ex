defmodule ServicesWeb.ProviderLive.Form do
  use ServicesWeb, :live_view

  alias Services.Service_provider
  alias Services.Service_provider.Provider

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage provider records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="provider-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:user_id]} type="text" label="Service Provider" value={@user_name} />
        <.input field={@form[:bio]} type="textarea" label="Bio" />
        <.input field={@form[:experience_year]} type="number" label="Experience year" />
        <.input field={@form[:is_verified]} type="checkbox" label="Is verified" />

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Provider</.button>
          <.button navigate={return_path(@current_scope, @return_to, @provider)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
    @spec mount(nil | maybe_improper_list() | map(), any(), map()) :: {:ok, map()}
    def mount(params, _session, socket) do
      {:ok,
       socket
       |> assign(:return_to, return_to(params["return_to"]))
       |> assign(:user_name, socket.assigns.current_scope.user.username)
       |> apply_action(socket.assigns.live_action, params)}
    end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    provider = Service_provider.get_provider!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Provider")
    |> assign(:provider, provider)
    |> assign(:form, to_form(Service_provider.change_provider(socket.assigns.current_scope, provider)))
  end

  defp apply_action(socket, :new, _params) do
    provider = %Provider{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Provider")
    |> assign(:provider, provider)
    |> assign(:form, to_form(Service_provider.change_provider(socket.assigns.current_scope, provider)))
  end

  @impl true
  def handle_event("validate", %{"provider" => provider_params}, socket) do
    changeset = Service_provider.change_provider(socket.assigns.current_scope, socket.assigns.provider, provider_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"provider" => provider_params}, socket) do
    save_provider(socket, socket.assigns.live_action, provider_params)
  end

  defp save_provider(socket, :edit, provider_params) do
    case Service_provider.update_provider(socket.assigns.current_scope, socket.assigns.provider, provider_params) do
      {:ok, provider} ->
        {:noreply,
         socket
         |> put_flash(:info, "Provider updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, provider)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_provider(socket, :new, provider_params) do
    case Service_provider.create_provider(socket.assigns.current_scope, provider_params) do
      {:ok, provider} ->
        {:noreply,
         socket
         |> put_flash(:info, "Provider created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, provider)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _provider), do: ~p"/provider"
  defp return_path(_scope, "show", provider), do: ~p"/provider/#{provider}"
end
