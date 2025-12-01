defmodule ServicesWeb.RatingLive.Show do
  use ServicesWeb, :live_view

  alias Services.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Rating {@rating.id}
        <:subtitle>This is a rating record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/ratings"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button  variant="dark-blue-gray" navigate={~p"/ratings/#{@rating}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit rating
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Rating">{@rating.rating}</:item>
        <:item title="Comment">{@rating.comment}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Ratings.subscribe_ratings(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Rating")
     |> assign(:rating, Ratings.get_rating!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Services.Ratings.Rating{id: id} = rating},
        %{assigns: %{rating: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :rating, rating)}
  end

  def handle_info(
        {:deleted, %Services.Ratings.Rating{id: id}},
        %{assigns: %{rating: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current rating was deleted.")
     |> push_navigate(to: ~p"/ratings")}
  end

  def handle_info({type, %Services.Ratings.Rating{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
