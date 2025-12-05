defmodule ServicesWeb.NotificationLive.Show do
  use ServicesWeb, :live_view
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
    <div class="p-2 m-3">
    </div>
    <section class=" bg-gray-300  dark:bg-gray-800 p-12 min-h-[60vh] mx-24 rounded">
    <h1 class="text-3xl text-center">{@current_notification.from_user.username}</h1>
    <h2>{@current_notification.bookings.providers_service.services.name}</h2>
    <div id="description_box" class="m-12">
    <h2 class="text-xl">description</h2>
    <p>{@current_notification.description}</p>
    </div>

    <%= if @current_notification.bookings.booking_status == "initiated" && @current_notification.bookings.providers_service.service_providers.user_id == @current_scope.user.id do%>
    <div class="flex gap-5 m-14">
    <.form for={%{}} phx-submit="open_form" class="">
      <button class="text-bold">Accept ✔️</button>
      </.form>
      <.form for={%{}} phx-submit="reject">
      <button type="submit" class="text-bold"> Reject ❌</button>
      <div class="flex">
      <.input hidden type="text" name="description" value="Your service was turned down please try other providers."/>
      <.input hidden type="text" name="notification_id" value={@current_notification.id}/>
      <.input hidden type="text" name="booking_id" value={@current_notification.booking_id}/>
      <.input hidden type="text" name="to_id" value={@current_notification.from_user.id}/>
      <.input hidden type="text" name="booking_status" value="rejected"/>
      <.input hidden type="text" name="rejected_at" value={@local_time}/>
      </div>
      </.form>
    </div>
    <%end%>
    <%= if @openform == true do%>
    <.form for={%{}} phx-submit="accept" class="m-12">
    <.input type="textarea" name="description" label="description" placeholder="Looking forward to provide service." value=""/>
    <.input hidden name="to_id" value={@current_notification.from_user.id}/>
    <.input type="text" hidden name="booking_status" value="accepted" />
    <.input hidden name="accepted_at" value={@local_time}/>
    <.input hidden name="notification_id" value={@current_notification.id}/>
    <.input hidden name="booking_id" value={@current_notification.bookings.id}/>
    <button>Accept</button>
    </.form>
    <%end%>
    <%= if @current_notification.bookings.booking_status == "accepted" && @current_notification.bookings.user_id == @current_scope.user.id do%>
    <button class="bg-green-600">PAY</button>
    <%end%>
    </section>
    </Layouts.app>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    current_time = NaiveDateTime.utc_now() |> DateTime.from_naive!("Etc/UTC")
    local_time = DateTime.shift_zone!(current_time, "Asia/Thimphu")

    current_notification = Services.Notifications.get_special_notification_by_id(id)
    {:ok, socket
    |> assign(:local_time, local_time)
    |> assign(:current_notification, current_notification)
    |> assign(:openform, false)
    }
  end

   def handle_event("open_form", _params, socket) do
    {:noreply, socket
    |> assign(:openform, true)}
  end

  def handle_event("reject", params, socket) do
    current_notification = Services.Notifications.get_special_notification_by_id(params["notification_id"])
    booking = Services.Bookings.get_booking!(socket.assigns.current_scope, params["booking_id"])
    naughty_change = %{"read" => true}

    Services.Notifications.update_special_notification(socket.assigns.current_scope, current_notification, naughty_change)
    case Services.Bookings.book_service(socket.assigns.current_scope, booking, params) do
    {:ok, booking} ->
      {:noreply,
        socket
        |> assign(:booking, booking)
        |> put_flash(:info, "Service was rejected you dont want money or what??")}

    {:error, _changeset} ->
      {:noreply,
        socket
        |> put_flash(:error, "couldnt happen this would mean the developers side error.")}
  end
  end

  def handle_event("accept", params, socket) do
    current_notification = Services.Notifications.get_special_notification_by_id(params["notification_id"])
    booking = Services.Bookings.get_booking!(socket.assigns.current_scope, params["booking_id"])
    naughty_change = %{"read" => true}

    Services.Notifications.update_special_notification(socket.assigns.current_scope, current_notification, naughty_change)
    case Services.Bookings.book_service(socket.assigns.current_scope, booking, params) do
    {:ok, booking} ->
      {:noreply,
        socket
        |> assign(:booking, booking)
        |> put_flash(:info, "Service was accepted you do want money huh.")}

    {:error, _changeset} ->
      {:noreply,
        socket
        |> put_flash(:error, "couldnt happen this would mean the developers side error.")}
  end
  end


end
