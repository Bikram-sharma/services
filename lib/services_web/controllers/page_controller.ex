defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
