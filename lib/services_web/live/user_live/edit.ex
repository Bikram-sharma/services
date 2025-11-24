defmodule ServicesWeb.UserLive.Edit do
  use ServicesWeb, :live_view


  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Edit User Details

      </.header>

      <div>
      <%= case @type do %>
      <% "user" -> %>
      <.header>
        Edit User Details

      </.header>
        <p>{@user.username}</p>
        <.custom_form for={@user_form} phx-change="validate_user" phx-submit="update_user">
        <.input type="text" placeholder={@user.username} label="Edit username" name="username" value={@user.username}/>
        <.input type="email" placeholder={@user.email} label="Edit Email" name="email" value={@user.email}/>
          <!-- password changes handled by the separate `@password_form` below -->
        <.button phx-disable-with="Saving..." variant="primary">change provider details</.button>
        </.custom_form>

         <.custom_form
        for={@password_form}
        id="password_form"
        phx-change="validate_password"
        phx-submit="update_password"

      >
        <input
          name={@password_form[:email].name}
          type="hidden"
          id="hidden_user_email"
          autocomplete="username"
          value={@user.email}
        />
        <.input
          field={@password_form[:password]}
          type="password"
          label="New password"
          autocomplete="new-password"
          required
        />
        <.input
          field={@password_form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          autocomplete="new-password"
        />
        <.button variant="primary" phx-disable-with="Saving...">
          Save Password
        </.button>
      </.custom_form>


      <% "provider" -> %>
      <div>
      <.header>
        Edit User Details

      </.header>
        <p>{@provider.users.username}</p>
        <.custom_form for={@user_form} phx-change="validate_user" phx-submit="update_user">
        <.input type="text" placeholder={@provider.users.username} label="Edit username" name="username" value={@provider.users.username}/>
        <.input type="email" placeholder={@provider.users.email} label="Edit Email" name="email" value={@provider.users.email}/>
        <%!-- <.input type="password" placeholder="password" label="change_password" name="password" value={}/> --%>
        <.button phx-disable-with="Saving..." variant="primary">change provider details</.button>
        </.custom_form>

         <.custom_form
        for={@password_form}
        id="password_form"
        phx-change="validate_password"
        phx-submit="update_password"

      >
        <input
          name={@password_form[:email].name}
          type="hidden"
          id="hidden_user_email"
          autocomplete="username"
          value={@provider.users.email}
        />
        <.input
          field={@password_form[:password]}
          type="password"
          label="New password"
          autocomplete="new-password"
          required
        />
        <.input
          field={@password_form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          autocomplete="new-password"
        />
        <.button variant="primary" phx-disable-with="Saving...">
          Save Password
        </.button>
      </.custom_form>

      </div>

      <div class="m-4">
      <.header>
        Provider Details
      </.header>
      <p class="text-red-500 m-4">remove from provider</p>
      <.custom_form for={@provider_form} phx-change="validate_provider" phx-submit="update_provider">
      <.input type="text" placeholder={@provider.bio} label="Edit BIO" name="bio" value={@provider.bio}/>
      <.input type="number" placeholder={@provider.years_of_experience} label="years of experience" name="years_of_experience" value={@provider.years_of_experience}/>
      <.input type="checkbox" placeholder={@provider.is_verified} label="is verified" name="is_verified" value={@provider.is_verified}/>
      <.button phx-disable-with="Saving..." variant="primary">change provider details</.button>
      </.custom_form>
      </div>


      <% "providers_service" -> %>
        <div>
      <.header>
        Edit User Details

      </.header>
        <p>{@provider.users.username}</p>
        <.custom_form for={@user_form} phx-change="validate_user" phx-submit="update_user">
        <.input type="text" placeholder={@provider.users.username} label="Edit username" name="username" value={@provider.users.username}/>
        <.input type="email" placeholder={@provider.users.email} label="Edit Email" name="email" value={@provider.users.email}/>
        <.button phx-disable-with="Saving..." variant="primary">change provider details</.button>
        </.custom_form>

        <.custom_form
        for={@password_form}
        id="password_form"
        phx-change="validate_password"
        phx-submit="update_password"

      >
        <input
          name={@password_form[:email].name}
          type="hidden"
          id="hidden_user_email"
          autocomplete="username"
          value={@provider.users.email}
        />
        <.input
          field={@password_form[:password]}
          type="password"
          label="New password"
          autocomplete="new-password"
          required
        />

        <.input
          field={@password_form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          autocomplete="new-password"
        />

        <.button variant="primary" phx-disable-with="Saving...">
          Save Password
        </.button>
      </.custom_form>
      </div>

      <div class="m-4">
      <.header>
        Provider Details
      </.header>
      <p class="text-red-500 m-4">remove from provider</p>
      <.custom_form for={@provider_form} phx-change="validate_provider" phx-submit="update_provider">
      <.input field={@provider_form[:bio]} type="text" placeholder={@provider.bio} label="bio" name="bio" value={@provider.bio}/>
      <.input field={@provider_form[:years_of_experience]} type="number" placeholder={@provider.years_of_experience} label="years of experience" name="years_of_experience" value={@provider.years_of_experience}/>
      <.input type="checkbox" placeholder={@provider.is_verified} label="is verified" name="is_verified" value={@provider.is_verified}/>
      <.button phx-disable-with="Saving..." variant="primary">change provider details</.button>
      </.custom_form>
      </div>
      <p>{@id}</p>

       <%= for service <- @providers_service do %>
       <div
       class="bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-lg transition-all duration-200 overflow-hidden mt-4">
       <.custom_form for={%{}} phx-submit="update_service" phx-change="validate_service">
       <.input type="text" placeholder={service.id} name="id" value={service.id} hidden/>
       <.input  type="select" prompt={service.services.name} prompt="select a service" options={@services} name="service_id" value={service.services.id}/>
       <.input type="number" placeholder={service.custom_price} label="change price" name="custom_price" value={service.custom_price}/>
       <.input  type="checkbox" placeholder={service.is_available} label="is available" name="is_available" value={service.is_available}/>
       <.button phx-disable-with="Saving..." variant="primary">change service details</.button>
       </.custom_form>


       </div>
       <%end%>

      <%end%>
      </div>


    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"user_id" => user_id}, _session, socket) do


    services = Services.Servicing.list_services()
    |> Enum.map(fn services ->
      {services.name, services.id}
    end)
    socket = assign(socket, :services, services)
    socket =
     case Services.ProviderService.get_all_details_of_single_user(user_id) do
      {:ok, %{type: :provider, data: provider}} ->
        socket
        |> assign(:type, "provider")
        |> assign(:provider, provider)
        |> assign(:user_form, to_form(Services.Accounts.change_user(provider.users)))
        |> assign(:provider_form, to_form(Services.ServiceProvider.change_provider_admin(provider)))
        |> assign(:id, provider.user_id)
        |> assign(:user, provider.users)
        |> assign(:password_form, to_form(Services.Accounts.change_user_password(provider.users, %{}, hash_password: false)))
        |> assign(:trigger_submit, false)
      {:ok, %{type: :user, data: user}} ->
        socket
        |> assign(:type, "user")
        |> assign(:user, user)
        |> assign(:id, user.id)
        |> assign(:trigger_submit, false)
        |> assign(:user_form, to_form(Services.Accounts.change_user(user)))

        |> assign(:password_form, to_form(Services.Accounts.change_user_password(user, %{}, hash_password: false)))
      {:ok, %{type: :providers_service, data: providers_service}, provider} ->
        socket
        |> assign(:type, "providers_service")
        |> assign(:providers_service, providers_service)
        |> assign(:id, provider.user_id)
        |> assign(:provider, provider)
        |> assign(:user, provider.users)
        |> assign(:user_form, to_form(Services.Accounts.change_user(provider.users)))
        |> assign(:provider_form, to_form(Services.ServiceProvider.change_provider_admin(provider)))
        |> assign(:password_form, to_form(Services.Accounts.change_user_password(provider.users, %{}, hash_password: false)))
        |> assign(:trigger_submit, false)
     end



     {:ok, socket}

  end

  @impl true


  def handle_event("validate_user", user_params, socket) do
    changeset = Services.Accounts.change_user(socket.assigns.user, user_params)
    {:noreply, assign(socket, user_form: to_form(changeset, action: :validate))}
  end

  def handle_event("validate_provider", provider_params, socket) do
    changeset = Services.ServiceProvider.change_provider_admin(socket.assigns.provider, provider_params)
    {:noreply, assign(socket, provider_form: to_form(changeset, action: :validate))}
  end

  def handle_event("validate_service", service_params, socket) do
    service = Services.ProviderService.get_providers_service_by_id(service_params["id"])
    changeset = Services.ProviderService.change_providers_service_admin(service, service_params)
    {:noreply, assign(socket, service_form: to_form(changeset, action: :validate))}
  end

  def handle_event("update_user", user_params, socket) do
    case Services.Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
        socket
        |> put_flash(:info, "User updated successfully")}
    end
  end

  def handle_event("update_provider", provider_params, socket) do
    case Services.ServiceProvider.update_provider_admin(socket.assigns.provider, provider_params) do
      {:ok, _provider} ->
        {:noreply,
        socket
        |> put_flash(:info, "Provider updated successfully")}

    end
  end

  def handle_event("update_service", service_params, socket) do
    service = Services.ProviderService.get_providers_service_by_id(service_params["id"])
    case Services.ProviderService.update_providers_service_admin(socket.assigns.provider.user_id, service, service_params) do
      {:ok, _providers_service} ->
        {:noreply,
        socket
        |> put_flash(:info, "Provider updated successfully")}


    end



  end


  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.user
      |> Services.Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.user

    case Services.Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, socket
        |> assign(:password_form, to_form(changeset))
        |> put_flash(:info, "password updated")}

      changeset ->
        {:noreply, socket
        |> assign(password_form: to_form(changeset, action: :insert))
        |> put_flash(:error, "couldn't update")}
    end
  end




  # def handle_event("update_user", %{"id" => id}, socket) do

  # end
end
