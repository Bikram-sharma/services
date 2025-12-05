defmodule ServicesWeb.RatingLive.Form do
  use ServicesWeb, :live_view

  alias Services.Ratings
  alias Services.Ratings.Rating

  @impl true
  def render(assigns) do
    ~H"""
  <Layouts.app flash={@flash} current_scope={@current_scope}>
  <section class="py-10 px-4 md:px-10 flex justify-center">
    <div class="w-full max-w-xl bg-white dark:bg-zinc-900
                shadow-lg dark:shadow-xl rounded-2xl p-8
                border border-gray-200 dark:border-zinc-700">

      <!-- Heading -->
      <div class="text-center mb-8">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
          {@page_title}
        </h1>
        <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
          Share your experience with this service.
        </p>
      </div>

      <!-- FORM -->
      <.form for={@form} id="rating-form" phx-change="validate" phx-submit="save" class="space-y-6">

        <!-- Rating -->
        <div>
          <label class="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2">
            Rating
          </label>

          <div class="flex items-center gap-1">
            <%= for star_value <- 1..5 do %>
              <button
                type="button"
                phx-click="set_rating"
                phx-value-rating={star_value}
                aria-label={"Rate #{star_value} stars"}
                class="text-4xl transition-all hover:scale-110 focus:outline-none"
              >
                <%= if star_value <= (get_rating_value(@form) || 0) do %>
                  <span class="text-yellow-400">★</span>
                <% else %>
                  <span class="text-gray-300 dark:text-gray-600">☆</span>
                <% end %>
              </button>
            <% end %>
          </div>

          <%= if get_rating_value(@form) do %>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
              {get_rating_value(@form)} {if get_rating_value(@form) == 1, do: "star", else: "stars"}
            </p>
          <% end %>

          <input type="hidden" name={@form[:rating].name} value={get_rating_value(@form) || ""} />

          <%= if @form[:rating].errors != [] do %>
            <p class="mt-1 text-sm text-rose-600 dark:text-rose-400">
              {translate_errors(@form[:rating].errors)}
            </p>
          <% end %>
        </div>

        <!-- Comment -->
        <div>
          <label class="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2">Comment</label>
          <textarea
            name={@form[:comment].name}
            class="w-full p-3 rounded-lg border border-gray-300 dark:border-zinc-700
                   bg-white dark:bg-zinc-800 text-gray-900 dark:text-gray-200
                   focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400
                   transition-all"
            rows="4"
            placeholder="Write your experience..."
          ><%= Phoenix.HTML.Form.input_value(@form, :comment) %></textarea>
        </div>

        <!-- User (read-only) -->
        <div>
          <label class="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2">User</label>
          <input
            type="text"
            class="w-full p-3 rounded-lg border border-gray-300 dark:border-zinc-700
                   bg-gray-100 dark:bg-zinc-800 text-gray-700 dark:text-gray-300 cursor-not-allowed"
            readonly
            value={@current_scope.user.username}
          />
        </div>

        <!-- Buttons -->
        <div class="pt-6 flex flex-col gap-3 text-center">
          <.button phx-disable-with="Saving..." variant="dark-blue-gray">
            Save Review
          </.button>

          <.button navigate={return_path(@current_scope, @return_to, @rating)} variant="blue-gray">
            Cancel
          </.button>
        </div>

      </.form>
    </div>
  </section>
</Layouts.app>
"""
  end

  # Helper function to safely get rating value
  defp get_rating_value(form) do
    case Phoenix.HTML.Form.input_value(form, :rating) do
      nil -> nil
      "" -> nil
      value when is_integer(value) -> value
      value when is_binary(value) -> String.to_integer(value)
      _ -> nil
    end
  end

  # Helper function to translate errors
  defp translate_errors(errors) do
    Enum.map_join(errors, ", ", fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
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
    rating = Ratings.get_rating!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Rating")
    |> assign(:rating, rating)
    |> assign(:form, to_form(Ratings.change_rating(socket.assigns.current_scope, rating)))
  end

  defp apply_action(socket, :new, _params) do
    rating = %Rating{rated_user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Rating")
    |> assign(:rating, rating)
    |> assign(:form, to_form(Ratings.change_rating(socket.assigns.current_scope, rating)))
  end

  @impl true
  def handle_event("set_rating", %{"rating" => rating_value}, socket) do
    # Convert string to integer
    rating = String.to_integer(rating_value)

    # Get current form data
    current_params =
      case socket.assigns.form.source do
        %Ecto.Changeset{changes: changes} ->
          changes |> Map.new(fn {k, v} -> {to_string(k), v} end)

        _ ->
          %{}
      end

    # Merge with new rating
    rating_params = Map.put(current_params, "rating", rating)

    # Update the changeset
    changeset =
      Ratings.change_rating(
        socket.assigns.current_scope,
        socket.assigns.rating,
        rating_params
      )

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    changeset =
      Ratings.change_rating(socket.assigns.current_scope, socket.assigns.rating, rating_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    save_rating(socket, socket.assigns.live_action, rating_params)
  end

  defp save_rating(socket, :edit, rating_params) do
    case Ratings.update_rating(socket.assigns.current_scope, socket.assigns.rating, rating_params) do
      {:ok, rating} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rating updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, rating)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_rating(socket, :new, rating_params) do
    case Ratings.create_rating(socket.assigns.current_scope, rating_params) do
      {:ok, rating} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rating created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, rating)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _rating), do: ~p"/"
  defp return_path(_scope, "show", rating), do: ~p"/ratings/#{rating}"
end
