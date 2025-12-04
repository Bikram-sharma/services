defmodule ServicesWeb.NotificationLive.Index do
alias Services.Bookings
  use ServicesWeb, :live_view
  def render(assigns) do


      ~H"""
      <Layouts.app flash={@flash}>
      <div name="naughty_navi" class="mt-6 mx-20 flex gap-1">

      <div class="bg-blue-600 mx p-2">
      <.link href="/notification">inbox</.link>
      </div>
      <div class="bg-red-400 p-2">
      <.link href="/notificationr">read</.link>
      </div>
      </div>
      <div class=" bg-gray-300  dark:bg-gray-800 p-12 min-h-[60vh] mx-3 rounded">
      <h1 class="text-xl">{@page_header}</h1>
      <%= case @list_of_inbox do%>
      <% {:notok, _any} -> %>
      <div class="flex flex-col items-center py-20">
      <svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" fill="gray" class="bi bi-inbox" viewBox="0 0 16 16">
      <path d="M4.98 4a.5.5 0 0 0-.39.188L1.54 8H6a.5.5 0 0 1 .5.5 1.5 1.5 0 1 0 3 0A.5.5 0 0 1 10 8h4.46l-3.05-3.812A.5.5 0 0 0 11.02 4zm9.954 5H10.45a2.5 2.5 0 0 1-4.9 0H1.066l.32 2.562a.5.5 0 0 0 .497.438h12.234a.5.5 0 0 0 .496-.438zM3.809 3.563A1.5 1.5 0 0 1 4.981 3h6.038a1.5 1.5 0 0 1 1.172.563l3.7 4.625a.5.5 0 0 1 .105.374l-.39 3.124A1.5 1.5 0 0 1 14.117 13H1.883a1.5 1.5 0 0 1-1.489-1.314l-.39-3.124a.5.5 0 0 1 .106-.374z"/>
      </svg>
      </div>


      <%{:ok, list} -> %>
      <div class="flex flex-col gap-2">
      <%= for inbox <- list do%>
      <div class="flex flex-col p-4 w-[70vh] justify-center bg-gray-700 rounded">
      <div class=" font-bold">{inbox.from_user.username}</div>
      <.link href={~p"/notification/#{inbox.id}/show"}>
      <div class="p-2">{inbox.description}.</div>
      </.link>
      <div class="flex gap-2">

      <%=if inbox.bookings.booking_status == "initiated" && inbox.bookings.providers_service.service_providers.user_id do%>
      <.form for={%{}} phx-submit="open_form" class="">
      <button class="text-bold">Accept ✔️</button>
      </.form>
      <.form for={%{}} phx-submit="reject">
      <button type="submit" class="text-bold"> Reject ❌</button>
      <div class="flex">
      <.input hidden type="text" name="description" value="Your service was turned down please try other providers."/>
      <.input hidden type="text" name="notification_id" value={inbox.id}/>
      <.input hidden type="text" name="booking_id" value={inbox.booking_id}/>
      <.input hidden type="text" name="to_id" value={inbox.from_user.id}/>
      <.input hidden type="text" name="booking_status" value="rejected"/>
      </div>
      </.form>
      <%end%>
      </div>
      <%dbg(inbox.bookings.booking_status)%>
      <%= if inbox.bookings.booking_status == "accepted"do%>
      <button class="bg-green-700 rounded p-2 w-56">PAY</button>
      <%end%>
      </div>

      <%end%>
      </div>
      <% _ ->%>
      <div>hello</div>
      <%end%>
      </div>
      </Layouts.app>


      """

  end

  def mount(params, _session, socket) do

  {:ok, socket
  |> assign(:openform, false)
  |> apply_action(socket.assigns.live_action, params)}

  end


  defp apply_action(socket, :inbox, _params) do
    list_of_inbox = case Services.Notifications.list_special_notification_provider(socket.assigns.current_scope.user.id) do
      [] ->
        {:notok, "nothing"}
      list -> {:ok, list}
    end

    socket
    |> assign(:list_of_inbox, list_of_inbox)
    |> assign(:page_header, "Inboxes")

  end

  defp apply_action(socket, :read, _params) do
    list_of_inbox = case Services.Notifications.list_special_notification_read(socket.assigns.current_scope.user.id) do
      [] ->
        {:notok, "nothing"}
      list -> {:ok, list}
    end
    socket
    |> assign(:list_of_inbox, list_of_inbox)
    |> assign(:page_header, "Reads")
  end

  defp apply_action(socket, :archive, _params) do
    list_of_inbox = case Services.Notifications.list_special_notification_archive(socket.assigns.current_scope.user.id) do
      [] ->
        {:notok, "nothing"}
      list -> {:ok, list}
    end
    socket
    |> assign(:list_of_inbox, list_of_inbox)
    |> assign(:page_header, "Archives")
  end

  def handle_event("open_form", _params, socket) do
    {:noreply, socket
    |> assign(:openform, true)}
  end

  def handle_event("reject", params, socket) do
    current_notification = Services.Notifications.get_special_notification_by_id(params["notification_id"])
    booking = Bookings.get_booking!(socket.assigns.current_scope, params["booking_id"])
    naughty_change = %{"read" => true}

    Services.Notifications.update_special_notification(socket.assigns.current_scope, current_notification, naughty_change)
    case Bookings.book_service(socket.assigns.current_scope, booking, params) do
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
end
