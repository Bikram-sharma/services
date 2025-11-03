defmodule ServicesWeb.BookingLive.Show do
  use ServicesWeb, :live_view

  alias Services.Bookings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Booking {@booking.id}
        <:subtitle>This is a booking record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/bookings"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/bookings/#{@booking}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit booking
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Schedule date time">{@booking.schedule_date_time}</:item>
        <:item title="Booked at">{@booking.booked_at}</:item>
        <:item title="Cancelled at">{@booking.cancelled_at}</:item>
        <:item title="Cancelled by">{@booking.cancelled_by}</:item>
        <:item title="Actual total price">{@booking.actual_total_price}</:item>
        <:item title="User address">{@booking.user_address}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Bookings.subscribe_bookings(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Booking")
     |> assign(:booking, Bookings.get_booking!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Services.Bookings.Booking{id: id} = booking},
        %{assigns: %{booking: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :booking, booking)}
  end

  def handle_info(
        {:deleted, %Services.Bookings.Booking{id: id}},
        %{assigns: %{booking: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current booking was deleted.")
     |> push_navigate(to: ~p"/bookings")}
  end

  def handle_info({type, %Services.Bookings.Booking{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
