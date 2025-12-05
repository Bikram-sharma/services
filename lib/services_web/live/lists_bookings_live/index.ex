defmodule ServicesWeb.ListsBookingsLive.Index do
  use ServicesWeb, :live_view

  alias Services.Bookings

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
    <div class="py-20 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 min-h-[60vh]">
      <div class="grid grid-cols-6 gap-5 mb-10">
         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-book-open" class="size-8"/>
            <p>Total Booking: {@total_bookings || 0} </p>
         </div>

         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-archive-box-arrow-down" class="size-8"/>
            <p>Draft: {@count["draft"] || 0} </p>
         </div>

         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-inbox-arrow-down" class="size-8"/>
            <p>Initiated: {@count["initiated"]} </p>
         </div>

         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-x-circle" class="size-8"/>
            <p>Rejected: {@count["rejected"] || 0} </p>
         </div>

         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-check-circle" class="size-8"/>
            <p>Accepted: {@count["accepted"] || 0} </p>
         </div>

         <div class="bg-[#121e30] border border-gray-200 rounded-lg text-lg text-white font-bold p-4 space-y-2">
            <.icon name="hero-clipboard-document-check" class="size-8"/>
            <p>Booked: {@count["booked"] || 0} </p>
         </div>
      </div>

      <%=if length(@all_bookings) != 0 do %>
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
        <:action :let={booking} label="Cancel">
            <.link
               phx-click={JS.push("cancel", value: %{id: booking.id}) |> hide("##{booking.id}")}
               data-confirm="Are you sure you want to cancel this action?"
               class="text-red-600 hover:underline"
            >
               Cancel
            </.link>
        </:action>
      </.table>

      <% else %>
         <.header> {@empty} </.header>
         <p class="mt-5">{@ouch_uaaa}</p>
      <% end %>

    </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do

   {:ok,
   socket
      |> assign(:page_title, "Listing Bookings")
      |> assign(:all_bookings, Bookings.get_all_booking())
      |> assign(:total_bookings, length(Bookings.get_all_booking()))
      |> assign(:count, Map.new(Bookings.count_booking_status()))
      |> assign(:empty, "No Bookings to Display")
      |> assign(:ouch_uaaa, "Harder!!!! more harder!!!! yey! yey!!!! yey!!! ouch you bitch!!!!")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
      booking = Bookings.get_booking!(socket.assigns.current_scope, id)
      {:ok, _} = Bookings.delete_booking(socket.assigns.current_scope, booking)

      {:noreply, stream_delete(socket, :bookings, booking)}
   end

   def handle_event("cancel", %{"id" => id}, socket) do
    booking = Bookings.get_booking!(socket.assigns.current_scope, id)
    list =[booking.user_id, booking.providers_service.service_providers.user_id]
    Enum.map(list, fn x -> cancel_booking(socket, booking, x) end)

        {:noreply,
        socket
        |> put_flash(:info, "the booking have been cancelled and now somebody might be sad.")}
 end

  defp cancel_booking(socket, booking, id) do
    local_time = NaiveDateTime.utc_now() |> DateTime.from_naive!("Etc/UTC") |> DateTime.shift_zone!("Asia/Thimphu")
    who_cancelled? = cond do
      socket.assigns.current_scope.user.id == booking.user_id -> "client"
      socket.assigns.current_scope.user.id == booking.providers_service.service_providers.user_id -> "provider"
      true -> "higher authority."
      end

    cancel_form = %{
      "booking_status" => "cancelled",
      "cancelled_at" => local_time,
      "description" => "the booking was cancelled by " <> who_cancelled?,
      "to_id" => id
    }
    Bookings.book_service(socket.assigns.current_scope, booking, cancel_form)
  end

end
