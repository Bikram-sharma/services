defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller
  alias Services.Servicing

  def home(conn, _params) do
    is_hidden = Servicing.is_hidden(conn.assigns.current_scope)
    render(conn, :home, is_hidden: is_hidden)
  end
end
