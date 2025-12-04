defmodule ServicesWeb.AboutController do
  use ServicesWeb, :controller

  def about(conn, _params) do

    render(conn, :about)
  end
end
