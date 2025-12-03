defmodule ServicesWeb.BookingLive.Form do
  use ServicesWeb, :live_view

  alias Services.Bookings

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="max-w-[80%] mx-auto">
        <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white mb-8 pb-2 text-center">
          Book Your Service
        </h2>

        <div class="grid grid-cols-1 lg:grid-cols-2 px-10">
          <div class="h-full p-6 bg-white dark:bg-gray-800  border border-gray-200 dark:border-gray-700 rounded-l-lg space-y-5">
            <h3 class="text-xl font-bold text-indigo-700 dark:text-indigo-400 border-b border-gray-200 dark:border-gray-700 pb-3 mb-4">
              Service and Providers Details
            </h3>
            <div class="grid place-items-center gap-0 min-h-[200px]">
              <div class="w-20 h-20 bg-black/80 rounded-full flex items-center justify-center shadow-lg ring-4 ring-violet-100 dark:ring-violet-900">
                <svg
                  class="w-12 h-12 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"
                  />
                </svg>
              </div>
              <p class="text-lg font-semibold text-gray-800 dark:text-gray-200">
                <span class="font-normal text-gray-600 dark:text-gray-400">
                  {@provider_service.service_providers.users.username}
                </span>
              </p>
              <p class="text-base text-gray-800 dark:text-gray-200">
                <span class="font-normal text-gray-600 dark:text-gray-400">
                  {@provider_service.service_providers.bio}
                </span>
              </p>
            </div>

            <div class="p-5 rounded-xl border border-gray-200 dark:border-gray-700 mt-4 space-y-3 ">
              <div class="space-y-3">
                <p class="text-lg font-semibold text-gray-800 dark:text-gray-200">
                  Service:
                  <span class="font-normal text-gray-600 dark:text-gray-400">
                    {@provider_service.services.name}
                  </span>
                </p>
                <p class="text-lg font-semibold text-gray-800 dark:text-gray-200">
                  Description:
                  <span class="font-normal text-gray-600 dark:text-gray-400">
                    {@provider_service.services.description}
                  </span>
                </p>
                <p class="text-lg font-semibold text-gray-800 dark:text-gray-200">
                  Category:
                  <span class="font-normal text-gray-600 dark:text-gray-400">
                    {@provider_service.services.category.name}
                  </span>
                </p>
              </div>

              <p class="text-xl font-bold text-green-600 dark:text-green-400">
                Rate: Nu.{@provider_service.custom_price} /-
              </p>
            </div>
          </div>

          <div id="carousel-container" class="overflow-hidden w-full" phx-hook="CarouselNext">
            <div id="inner-carousel" class="flex transition-transform duration-900">
              <div class="w-full flex-shrink-0">
                <!-- ----------Booking Form Start---------- -->

                <.form
                  for={%{}}
                  phx-submit="create_booking_draft"
                  class="h-full dark:text-indigo-400 p-6 bg-white dark:bg-gray-800  border border-gray-200 dark:border-gray-700 rounded-r-lg space-y-6 "
                >
                  <h3 class="text-xl font-bold text-indigo-700 dark:text-indigo-400 border-b border-gray-200 dark:border-gray-700 pb-3 mb-4">
                    Complete Booking Details
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    Fill in your details below to proceed to the payment step.
                  </p>

                  <.input
                    required
                    label="address"
                    name="user_address"
                    placeholder="adress of service"
                    type="text"
                    value=""
                  />
                  <.input
                    required
                    label="email"
                    name="email"
                    placeholder="provide your email"
                    type="text"
                    value=""
                  />
                  <.input
                    required
                    label="contact number"
                    type="number"
                    name="contact"
                    placeholder="provide contact details"
                    value=""
                  />
                  <.input hidden name="user_id" value={@id} />
                  <.input hidden name="provider_service_id" value={@provider_service.id} />
                  <.input hidden name="booking_status" value="draft" />
                  <.input
                    hidden
                    name="actual_total_price"
                    value={@provider_service.custom_price}
                  />
                  <div class="flex flex-col sm:flex-row items-center justify-between pt-4 border-t-2 border-dashed border-gray-300 dark:border-gray-600 mt-6">
                    <button
                      disabled={@form_submitting}
                      type="submit"
                      class="w-full sm:w-auto flex items-center justify-center space-x-2 bg-[#121e30] dark:bg-indigo-600 text-white px-6 py-2 rounded-lg font-semibold text-lg transition-all duration-300 shadow-xl hover:shadow-2xl transform hover:scale-105 dark:hover:bg-indigo-500"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="20"
                        height="20"
                        fill="currentColor"
                        class="bi bi-credit-card"
                        viewBox="0 0 16 16"
                      >
                        <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v1h14V4a1 1 0 0 0-1-1zm13 4H1v5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z" />
                        <path d="M2 10a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1v1a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z" />
                      </svg>
                      {if @form_submitting, do: "Processing...", else: "Proceed"}
                    </button>
                    <button
                      type="button"
                      id="carousel-next-btn"
                      data-carousel-next
                      hidden
                    >
                    </button>
                  </div>
                </.form>
                
    <!-- ----------Booking Form End---------- -->
              </div>

              <div class="w-full flex-shrink-0">
                <!-- ---------Service Form Start--------- -->
                <.form
                  for={%{}}
                  phx-submit="book_service"
                  class="p-6 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-r-lg space-y-6"
                >
                  <h3 class="text-xl font-bold text-indigo-700 dark:text-indigo-400 border-b border-gray-200 dark:border-gray-700 pb-3 mb-4">
                    Enter the service detail
                  </h3>

                  <.input
                    required
                    placeholder="enter brief discussion about the service you are trying to avail."
                    label="description"
                    type="textarea"
                    name="description"
                    value=""
                  />
                  <.input
                    required
                    type="datetime-local"
                    label="date of service."
                    name="schedule_date_time"
                    value=""
                  />
                  <.input
                    type="datetime-local"
                    placeholder={@local_time}
                    name="initiated_at"
                    value={@local_time}
                    hidden
                  />
                  <.input type="text" hidden name="booking_status" value="initiated" />
                  
    <!-- ----------The button to open modal---------- -->
                  <label
                    for="my_modal_6"
                    class="inline-flex text-sm text-indigo-700 dark:text-indigo-400 hover:text-indigo-800 dark:hover:text-indigo-300 cursor-pointer underline decoration-dotted underline-offset-2"
                  >
                    Read terms and conditions
                    <svg
                      class="w-4 h-4 no-underline"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                        clip-rule="evenodd"
                      >
                      </path>
                    </svg>
                  </label>

                  <div class="flex flex-col text-gray-700 dark:text-gray-300">
                    <label>
                      <input type="checkbox" required class="text-indigo-600 dark:text-indigo-400" />
                      I agree to the Terms & Conditions <span class="text-red-500">*</span>
                    </label>
                    <label>
                      <input type="checkbox" required class="text-indigo-600 dark:text-indigo-400" />
                      I agree to the Cancellation & Refund Policy <span class="text-red-500">*</span>
                    </label>
                  </div>

                  <div class="flex flex-col sm:flex-row items-center justify-between pt-4 border-t-2 border-dashed border-gray-300 dark:border-gray-600 mt-6">
                    <button
                      type="button"
                      class="flex items-center cursor-pointer text-indigo-700 dark:text-indigo-400"
                      data-carousel-prev
                    >
                      Previous
                    </button>
                    <button
                      type="submit"
                      class="w-full sm:w-auto flex items-center justify-center space-x-2 bg-[#121e30] dark:bg-indigo-600 text-white px-6 py-2 rounded-lg font-semibold text-lg transition-all duration-300 shadow-xl hover:shadow-2xl transform hover:scale-105 dark:hover:bg-indigo-500"
                    >
                      Book
                    </button>
                  </div>
                </.form>
                <!-- ----------Payment Form End---------- -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, %{assigns: %{live_action: :form}} = socket) do
    is_hidden = Services.Servicing.is_hidden(socket.assigns.current_scope)
    provider_service = Services.ProviderService.get_providers_service_by_id(id)

    current_time =
      NaiveDateTime.utc_now()
      |> DateTime.from_naive!("Etc/UTC")

    local_time =
      case DateTime.shift_zone(current_time, "Asia/Thimphu") do
        {:ok, time} -> time
        {:error, error} -> error
      end

    socket =
      socket
      |> assign(:local_time, local_time)
      |> assign(:id, socket.assigns.current_scope.user.id)
      |> assign(:provider_service, provider_service)
      |> assign(:is_hidden, is_hidden)
      |> assign(:form_submitting, false)

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "Please start a booking from a specific service.")
     |> push_navigate(to: ~p"/services")}
  end

  @impl true
  def handle_event("create_booking_draft", params, socket) do
    socket = assign(socket, :form_submitting, true)

    case Bookings.create_booking(socket.assigns.current_scope, params) do
      {:ok, booking} ->
        {:noreply,
         socket
         |> assign(:booking, booking)
         |> assign(:form_submitting, false)
         |> push_event("trigger-carousel-next", %{})}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> assign(:form_submitting, false)
         |> put_flash(:error, "couldnt happen this would mean the developers side error.")}
    end
  end

  @impl true
  def handle_event("book_service", params, socket) do
    case socket.assigns[:booking] do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "You must complete the first step before booking.")}

      booking ->
        case Services.Bookings.book_service(
               socket.assigns.current_scope,
               booking,
               params
             ) do
          {:ok, _booking} ->
            {:noreply,
             socket
             |> put_flash(:info, "Your service has been booked successfully!")
             |> push_navigate(to: ~p"/bookings")}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(:error, "There was an error while booking your service.")}
        end
    end
  end
end
