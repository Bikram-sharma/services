defmodule ServicesWeb.BookingLive.Index do
  use ServicesWeb, :live_view

  alias Services.Bookings

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-20 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 min-h-[60vh]">
      <.header>
        Your Bookings
      </.header>
      <%= if length(@streams.bookings.inserts) != 0 do %>
        <.table
          id="bookings"
          rows={@streams.bookings}
        >
          <:col :let={{_id, booking}} label="Service">
            {(booking.providers_service && booking.providers_service.services.name) || "undefined"}
          </:col>
          <:col :let={{_id, booking}} label="Provider">
            {(booking.providers_service && booking.providers_service.service_providers.users.username) ||
              "undefined"}
          </:col>
          <:col :let={{_id, booking}} label="Cost">
            {"Nu. #{(booking.providers_service && booking.providers_service.custom_price) || "-"}"}
          </:col>
          <:col :let={{_id, booking}} label="Status">{booking.booking_status}</:col>
          <:action :let={{id, booking}} label="Cancel">
            <.link
              phx-click={JS.push("delete", value: %{id: booking.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
              class="text-red-600 hover:underline"
            >
              Cancel
            </.link>
          </:action>
        </.table>
      <% else %>
        <div class="flex flex-col items-center justify-center py-16 text-gray-600">
          <.icon name="hero-calendar" class="w-12 h-12 text-gray-400" />
          <p class="text-lg font-medium">No bookings found.</p>
          <p class="mt-2">
            <.link navigate={~p"/bookings/new"} class="text-blue-600 underline font-semibold">
              Create your first booking?
            </.link>
          </p>
        </div>
      <% end %>
    </div>
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
