defmodule ServicesWeb.RatingLive.Form do
  use ServicesWeb, :live_view

  alias Services.Ratings
  alias Services.Ratings.Rating

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage rating records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="rating-form" phx-change="validate" phx-submit="save">

        <!-- Star Rating Field -->
        <div class="space-y-2">
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Rating
          </label>

          <div class="flex items-center gap-2">
            <%= for star_value <- 1..5 do %>
              <button
                type="button"
                phx-click="set_rating"
                phx-value-rating={star_value}
                class="text-3xl transition-all hover:scale-110 focus:outline-none"
                aria-label={"Rate #{star_value} stars"}
              >
                <%= if star_value <= (get_rating_value(@form) || 0) do %>
                  <span class="text-yellow-400">★</span>
                <% else %>
                  <span class="text-gray-300">☆</span>
                <% end %>
              </button>
            <% end %>

            <%= if get_rating_value(@form) do %>
              <span class="ml-2 text-sm text-gray-600">
                {get_rating_value(@form)} {if get_rating_value(@form) == 1, do: "star", else: "stars"}
              </span>
            <% end %>
          </div>

          <!-- Hidden input to store the rating value -->
          <input type="hidden" name={@form[:rating].name} value={get_rating_value(@form) || ""} />

          <!-- Display errors if any -->
          <%= if @form[:rating].errors != [] do %>
            <p class="mt-2 text-sm text-rose-600">
              <%= translate_errors(@form[:rating].errors) %>
            </p>
          <% end %>
        </div>

        <.input field={@form[:comment]} type="textarea" label="Comment" />

        <footer class="flex flex-col gap-4 w-full text-center">
          <.button phx-disable-with="Saving..." variant="dark-blue-gray">Save Review</.button>
          <.button navigate={return_path(@current_scope, @return_to, @rating)} variant="blue-gray">Cancel</.button>
        </footer>
      </.form>
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
    current_params = case socket.assigns.form.source do
      %Ecto.Changeset{changes: changes} ->
        changes |> Map.new(fn {k, v} -> {to_string(k), v} end)
      _ ->
        %{}
    end

    # Merge with new rating
    rating_params = Map.put(current_params, "rating", rating)

    # Update the changeset
    changeset = Ratings.change_rating(
      socket.assigns.current_scope,
      socket.assigns.rating,
      rating_params
    )

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    changeset = Ratings.change_rating(socket.assigns.current_scope, socket.assigns.rating, rating_params)
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

  defp return_path(_scope, "index", _rating), do: ~p"/ratings"
  defp return_path(_scope, "show", rating), do: ~p"/ratings/#{rating}"
end
