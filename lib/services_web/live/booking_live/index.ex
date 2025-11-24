defmodule ServicesWeb.BookingLive.Index do
  use ServicesWeb, :live_view

  alias Services.Bookings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Bookings
        <:actions>
          <.button variant="dark-blue-gray" navigate={~p"/bookings/new"}>
            <.icon name="hero-plus" /> New Booking
          </.button>
        </:actions>
      </.header>

      <.table
        id="bookings"
        rows={@streams.bookings}
        row_click={fn {_id, booking} -> JS.navigate(~p"/bookings/#{booking}") end}
      >
        <:col :let={{_id, booking}} label="Schedule date time">{booking.schedule_date_time}</:col>
        <:col :let={{_id, booking}} label="Booked at">{booking.booked_at}</:col>
        <:col :let={{_id, booking}} label="Cancelled at">{booking.cancelled_at}</:col>
        <:col :let={{_id, booking}} label="Cancelled by">{booking.cancelled_by}</:col>
        <:col :let={{_id, booking}} label="Actual total price">{booking.actual_total_price}</:col>
        <:col :let={{_id, booking}} label="User address">{booking.user_address}</:col>
        <:action :let={{_id, booking}}>
          <div class="sr-only">
            <.link navigate={~p"/bookings/#{booking}"}>Show</.link>
          </div>
          <.link navigate={~p"/bookings/#{booking}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, booking}}>
          <.link
            phx-click={JS.push("delete", value: %{id: booking.id}) |> hide("##{id}")}
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
    is_hidden = Services.Servicing.is_hidden(socket.assigns.current_scope)

    if connected?(socket) do
      Bookings.subscribe_bookings(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Bookings")
     |> assign(:is_hidden, is_hidden)
     |> stream(:bookings, list_bookings(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    booking = Bookings.get_booking!(socket.assigns.current_scope, id)
    {:ok, _} = Bookings.delete_booking(socket.assigns.current_scope, booking)

    {:noreply, stream_delete(socket, :bookings, booking)}
  end

  @impl true
  def handle_info({type, %Services.Bookings.Booking{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :bookings, list_bookings(socket.assigns.current_scope), reset: true)}
  end

  defp list_bookings(current_scope) do
    Bookings.list_bookings(current_scope)
  end
end
