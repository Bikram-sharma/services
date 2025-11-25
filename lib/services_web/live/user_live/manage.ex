defmodule ServicesWeb.UserLive.Manage do
  use ServicesWeb, :live_view

  alias Services.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <div class="flex items-center justify-evenly">
        <div class="px-8 py-2 place-items-center">
          <div class="py-2">
            <p class="italic font-semibold">
              “Access grants power, responsibility gives it purpose.”
            </p>
          </div>
          <h1 class="text-2xl font-semibold text-gray-900 underline">User Management</h1>
          <p class="mt-1 text-sm text-gray-500">
            Manage user accounts, roles, and permissions across the system.
          </p>
          <p class="text-sm text-gray-500">
            Total Users: {length(@streams.users.inserts)}
          </p>
        </div>
      </div>
    </.header>

    <.table
      id="users"
      rows={@streams.users}
    >
      <:col :let={{_id, user}} label="User">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-blue-500 to-purple-600 text-white font-semibold">
            {String.first(user.username) |> String.upcase()}
          </div>
          <div>
            <div class="font-medium text-gray-900">
              {user.username}
              <%= if user.id == @current_scope.user.id do %>
                <span class="ml-2 inline-flex items-center rounded-full bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700 ring-1 ring-inset ring-blue-700/10">
                  You
                </span>
              <% end %>
            </div>
            <%= if user.email do %>
              <div class="text-sm text-gray-500">{user.email}</div>
            <% end %>
          </div>
        </div>
      </:col>

      <:col :let={{_id, user}} label="Edit">
        <.link
          navigate={~p"/manage/#{user.id}/edit"}
          class="inline-flex items-center gap-1.5 rounded-md pr-2.5 py-1.5 text-sm font-medium text-blue-600 hover:bg-blue-50 hover:text-blue-700 transition-colors"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
          </svg>
          Edit
        </.link>
      </:col>

      <:col :let={{_id, user}} label="Role">
        <span class={[
          "inline-flex items-center rounded-full px-2.5 py-1 text-xs font-semibold",
          role_badge_class(user.role)
        ]}>
          {format_role(user.role)}
        </span>
      </:col>

      <:col :let={{_id, user}} label="Status">
        <%= if is_nil(user.deactivated_at) do %>
          <span class="inline-flex items-center gap-1.5">
            <span class="h-2 w-2 rounded-full bg-green-500"></span>
            <span class="text-sm text-gray-600">Active</span>
          </span>
        <% else %>
          <span class="inline-flex items-center gap-1.5">
            <span class="h-2 w-2 rounded-full bg-gray-400"></span>
            <span class="text-sm text-gray-600">Inactive</span>
          </span>
        <% end %>
      </:col>

      <:action :let={{_id, user}}>
        <%= if @current_scope.user.role == "super_admin" and user.id != @current_scope.user.id do %>
          <.form
            for={%{}}
            phx-change="change_role"
            class="min-w-[140px]"
          >
            <.input type="text" name="user_id" value={user.id} hidden/>

            <.input
              type="select"
              name="role"
              value={user.role}
              options={@roles}
              class="text-sm"
              disabled={@changing_role == user.id}
              phx-hook="ConfirmRoleChange"
              id={"role-select-#{user.id}"}
              data-username={user.username}
            />

            <%= if @changing_role == user.id do %>
              <div class="mt-1 flex items-center gap-1 text-xs text-gray-500">
                <svg
                  class="h-3 w-3 animate-spin"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                  >
                  </circle>
                  <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  >
                  </path>
                </svg>
                Updating...
              </div>
            <% end %>
          </.form>
        <% else %>
            <%= if @current_scope.user.role != "super_admin" do %>
              <span class="text-sm text-gray-400">No permission</span>
            <% end %>

        <% end %>
      </:action>

      <:action :let={{_id, user}}>
        <%= if is_nil(user.deactivated_at) do %>
          <.link
            phx-click={JS.push("deactivate", value: %{id: user.id})}
            data-confirm={"Are you sure you want to deactivate #{user.username}?"}
            class="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-orange-600 hover:bg-orange-50 hover:text-orange-700 transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-4 w-4"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path d="M10 2a.75.75 0 01.75.75v1.5a.75.75 0 01-1.5 0v-1.5A.75.75 0 0110 2zM10 15a.75.75 0 01.75.75v1.5a.75.75 0 01-1.5 0v-1.5A.75.75 0 0110 15zM10 7a3 3 0 100 6 3 3 0 000-6zM15.657 5.404a.75.75 0 10-1.06-1.06l-1.061 1.06a.75.75 0 001.06 1.06l1.06-1.06zM6.464 14.596a.75.75 0 10-1.06-1.06l-1.06 1.06a.75.75 0 001.06 1.06l1.06-1.06zM18 10a.75.75 0 01-.75.75h-1.5a.75.75 0 010-1.5h1.5A.75.75 0 0118 10zM5 10a.75.75 0 01-.75.75h-1.5a.75.75 0 010-1.5h1.5A.75.75 0 015 10zM14.596 15.657a.75.75 0 001.06-1.06l-1.06-1.061a.75.75 0 10-1.06 1.06l1.06 1.06zM5.404 6.464a.75.75 0 001.06-1.06l-1.06-1.06a.75.75 0 10-1.06 1.06l1.06 1.06z" />
            </svg>
            Deactivate
          </.link>
        <% else %>
          <.link
            phx-click={JS.push("activate", value: %{id: user.id})}
             data-confirm={"Are you sure you want to deactivate #{user.username}?"}
            class="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-green-600 hover:bg-green-50 hover:text-green-700 transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-4 w-4"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path
                fill-rule="evenodd"
                d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z"
                clip-rule="evenodd"
              />
            </svg>
            Activate
          </.link>
        <% end %>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    roles = [{"Admin", "admin"}, {"User", "user"}]

    {:ok,
     socket
     |> assign(:page_title, "Listing Users")
     |> assign(:roles, roles)
     |> assign(:changing_role, nil)
     |> stream(:users, list_all_users())}
  end

  @impl true
  def handle_event("change_role", %{"role" => role, "user_id" => user_id}, socket) do
    case Accounts.update_user_role(user_id, role) do
      {:ok, updated_user} ->
        {:noreply, stream_insert(socket, :users, updated_user)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to update role")}
    end
  end
   def handle_event("deactivate", %{"id" => user_id},socket) do
  case Accounts.deactivate_user_by_admin(user_id) do
      {:ok, updated_user} ->
        {:noreply,
         socket
         |> stream_insert(:users, updated_user)
         |> put_flash(:info, "#{updated_user.username} has been deactivated successfully")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to deactivate user")}
    end

  end

   def handle_event("activate", %{"id" => user_id}, socket) do
      case Accounts.activate_user_by_admin(user_id) do
        {:ok, updated_user} ->
          {:noreply,
           socket
           |> stream_insert(:users, updated_user)
           |> put_flash(:info, "#{updated_user.username} has been activated successfully")}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Failed to activate user")}
      end

  end


  @impl true
  def handle_info({type, _user}, socket) when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :users, list_all_users(), reset: true)}
  end

  defp list_all_users() do
    Accounts.list_all_users()
  end



  defp role_badge_class("super_admin"),
    do: "bg-purple-100 text-purple-800 ring-1 ring-purple-600/20"

  defp role_badge_class("admin"), do: "bg-blue-100 text-blue-800 ring-1 ring-blue-600/20"
  defp role_badge_class("user"), do: "bg-gray-100 text-gray-800 ring-1 ring-gray-600/20"
  defp role_badge_class(_), do: "bg-gray-100 text-gray-800 ring-1 ring-gray-600/20"

  defp format_role(role) do
    role
    |> to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
