defmodule ServicesWeb.Plugs do
  alias Services.Servicing
  import Phoenix.Controller
  import Plug.Conn
  def init(default), do: default

  def call(conn, _opts) do
    conn = check_user_active(conn)

    if conn.halted do
      conn
    else
      is_hidden = Servicing.is_hidden(conn.assigns.current_scope)

      page_title =
        if conn.assigns.current_scope && conn.assigns.current_scope.user,
          do: conn.assigns.current_scope.user.username,
          else: "Services"

      conn
      |> assign(:page_title, page_title)
      |> assign(:is_hidden, is_hidden)
    end
  end

  defp check_user_active(conn) do
    case conn.assigns[:current_scope] do
      nil ->
        conn

      scope ->
        case scope.user do
          nil ->
            conn

          user ->
            if user.deactivated_at do
              conn
              |> put_flash(:error, "Your account has been deactivated. Please contact support.")
              |> ServicesWeb.UserAuth.log_out_user()
              |> redirect(to: "/")
              |> halt()
            else
              conn
            end
        end
    end
  end
end
