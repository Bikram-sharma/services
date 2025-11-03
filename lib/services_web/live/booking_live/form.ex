defmodule ServicesWeb.BookingLive.Form do
  use ServicesWeb, :live_view

  alias Services.Bookings
  alias Services.Bookings.Booking

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage booking records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="booking-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:schedule_date_time]} type="datetime-local" label="Schedule date time" />
        <.input field={@form[:booked_at]} type="datetime-local" label="Booked at" />
        <.input field={@form[:cancelled_at]} type="datetime-local" label="Cancelled at" />
        <.input field={@form[:cancelled_by]} type="text" label="Cancelled by" />
        <.input field={@form[:actual_total_price]} type="number" label="Actual total price" step="any" />
        <.input field={@form[:user_address]} type="text" label="User address" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Booking</.button>
          <.button navigate={return_path(@current_scope, @return_to, @booking)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    booking = Bookings.get_booking!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Booking")
    |> assign(:booking, booking)
    |> assign(:form, to_form(Bookings.change_booking(socket.assigns.current_scope, booking)))
  end

  defp apply_action(socket, :new, _params) do
    booking = %Booking{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Booking")
    |> assign(:booking, booking)
    |> assign(:form, to_form(Bookings.change_booking(socket.assigns.current_scope, booking)))
  end

  @impl true
  def handle_event("validate", %{"booking" => booking_params}, socket) do
    changeset = Bookings.change_booking(socket.assigns.current_scope, socket.assigns.booking, booking_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"booking" => booking_params}, socket) do
    save_booking(socket, socket.assigns.live_action, booking_params)
  end

  defp save_booking(socket, :edit, booking_params) do
    case Bookings.update_booking(socket.assigns.current_scope, socket.assigns.booking, booking_params) do
      {:ok, booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, booking)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_booking(socket, :new, booking_params) do
    case Bookings.create_booking(socket.assigns.current_scope, booking_params) do
      {:ok, booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, booking)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _booking), do: ~p"/bookings"
  defp return_path(_scope, "show", booking), do: ~p"/bookings/#{booking}"
end
