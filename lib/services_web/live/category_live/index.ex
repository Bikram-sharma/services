defmodule ServicesWeb.CategoryLive.Index do
  use ServicesWeb, :live_view

  alias Services.Servicing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Categories
        <:actions>
          <.button variant="dark-blue-gray" navigate={~p"/categories/new"}>
            <.icon name="hero-plus" /> New Category
          </.button>
        </:actions>
      </.header>

      <.table
        id="categories"
        rows={@streams.categories}
        row_click={fn {_id, category} -> JS.navigate(~p"/categories/#{category}") end}
      >
        <:col :let={{_id, category}} label="Name">{category.name}</:col>
        <:col :let={{_id, category}} label="Description">{category.description}</:col>
        <:action :let={{_id, category}}>
          <div class="sr-only">
            <.link navigate={~p"/categories/#{category}"}>Show</.link>
          </div>
          <.link navigate={~p"/categories/#{category}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, category}}>
          <.link
            phx-click={JS.push("delete", value: %{id: category.id}) |> hide("##{id}")}
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
      Servicing.subscribe_categories(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Categories")
     |> stream(:categories, list_categories())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Servicing.get_category!(socket.assigns.current_scope, id)
    {:ok, _} = Servicing.delete_category(socket.assigns.current_scope, category)

    {:noreply, stream_delete(socket, :categories, category)}
  end

  @impl true
  def handle_info({type, %Services.Servicing.Category{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :categories, list_categories(), reset: true)}
  end

  defp list_categories() do
    Servicing.list_categories()
  end
end
