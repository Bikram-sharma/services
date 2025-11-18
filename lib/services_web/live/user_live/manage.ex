defmodule ServicesWeb.UserLive.Manage do
  use ServicesWeb, :live_view

  alias Services.Accounts

  @impl true
  def render(assigns) do
    ~H"""

      <.header>
        Listing Users
      </.header>

      <.table
        id="users"
        rows={@streams.users}
      >
        <:col :let={{_id, user}} label="Name">
          <%= user.username %>
        </:col>

        <:col :let={{_id, user}} label="Role">
          <%= user.role %>
        </:col>

        <:action :let={{_id, user}}>
        <.form for={%{}} phx-change="change_role">

          <.input type="text" hidden name="user_id" value={user.id} />

          <.input
            type="select"
            name="role"
            value={user.role}
            options={@roles}
            label="change role"
          />
        </.form>

        </:action>

        <:action :let={{id, user}}>
          <.link
            phx-click={JS.push("delete", value: %{id: user.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>

    """
  end

  @impl true
  def mount(_params, _session, socket) do
    roles = [{"Admin", "admin"}, {"Client", "client"}]



    {:ok,
     socket
     |> assign(:page_title, "Listing Users")
     |> assign(:roles, roles)
     |> assign(:layout, {ServicesWeb.Layouts, :root_no_nav})
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Accounts.delete_user(id) do
      {:ok, _} ->
        {:noreply, stream_delete(socket, :users, id)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to delete user")}
    end
  end

  @impl true
  def handle_info({type, _user}, socket) when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :users, list_all_users(), reset: true)}
  end

  defp list_all_users() do
    Accounts.list_all_users()
  end
end
