defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:ratings, Services.Ratings.list_ratings())
    |> render()
  end
end
