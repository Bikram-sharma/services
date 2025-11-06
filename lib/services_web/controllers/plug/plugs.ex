defmodule ServicesWeb.Plugs do

  import Plug.Conn
  def init(default), do: default


  def call(conn, _opts) do
    page_title = if conn.assigns.current_scope && conn.assigns.current_scope.user, do: conn.assigns.current_scope.user.username, else: "Services"
    conn
    |> assign(:page_title, page_title)


  end
end
