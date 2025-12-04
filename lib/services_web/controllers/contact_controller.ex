defmodule ServicesWeb.ContactController do
  use ServicesWeb, :controller

  def contact(conn, _params) do
    render(conn, :contact)
  end
end
