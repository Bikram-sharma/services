defmodule ServicesWeb.RatingLive.Index do
  use ServicesWeb, :live_view

  alias Services.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Ratings
        <:actions>
          <.button variant="dark-blue-gray" navigate={~p"/ratings/new"}>
            <.icon name="hero-plus" /> New Rating
          </.button>
        </:actions>
      </.header>

      <.table
        id="ratings"
        rows={@streams.ratings}
        row_click={fn {_id, rating} -> JS.navigate(~p"/ratings/#{rating}") end}
      >
        <:col :let={{_id, rating}} label="Rating">{rating.rating}</:col>
        <:col :let={{_id, rating}} label="Comment">{rating.comment}</:col>
        <:action :let={{_id, rating}}>
          <div class="sr-only">
            <.link navigate={~p"/ratings/#{rating}"}>Show</.link>
          </div>
          <.link navigate={~p"/ratings/#{rating}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, rating}}>
          <.link
            phx-click={JS.push("delete", value: %{id: rating.id}) |> hide("##{id}")}
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
      Ratings.subscribe_ratings(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Ratings")
     |> stream(:ratings, list_ratings(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rating = Ratings.get_rating!(socket.assigns.current_scope, id)
    {:ok, _} = Ratings.delete_rating(socket.assigns.current_scope, rating)

    {:noreply, stream_delete(socket, :ratings, rating)}
  end

  @impl true
  def handle_info({type, %Services.Ratings.Rating{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :ratings, list_ratings(socket.assigns.current_scope), reset: true)}
  end

  defp list_ratings(current_scope) do
    Ratings.list_ratings(current_scope)
  end
end
