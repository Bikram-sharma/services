defmodule ServicesWeb.ListsBookingsLive.Index do
  use ServicesWeb, :live_view

  alias Services.Bookings

  def render(assigns) do
    ~H"""
    <div class="py-20 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 min-h-[60vh]">
      <.header> All Bookings </.header>

      <.table id="all_bookings" rows={@all_bookings}>
        <:col :let={booking} label="Service Booked">
           { booking.providers_service.services.name }
        </:col>

        <:col :let={booking} label="Service Provider">
           { booking.providers_service.service_providers.users.username }
        </:col>

        <:col :let={booking} label="Booked By">
            { booking.users.username }
        </:col>

        <:col :let={booking} label="Booked At">
           { booking.schedule_date_time }
        </:col>

        <:col :let={booking} label="Address">
           { booking.user_address }
        </:col>

        <:col :let={booking} label="Contact">
           { booking.contact }
        </:col>

        <:col :let={booking} label="Status">
           { booking.booking_status }
        </:col>

        <:col :let={booking} label="Price">
           { booking.actual_total_price }
        </:col>
      </.table>

      <p class="mt-5">{@ouch_uaaa}</p>

    </div>
    """
  end

  def mount(_params, _session, socket) do

   result = Bookings.get_all_booking(nil)
   dbg(result)

   {:ok,
   socket
      |> assign(:page_title, "Listing Bookings")
      |> assign(:all_bookings, Bookings.get_all_booking(nil))
      |> assign(:ouch_uaaa, "Harder!!!! more harder!!!! yey! yey!!!! yey!!! ouch you bitch!!!!")}
  end

end
