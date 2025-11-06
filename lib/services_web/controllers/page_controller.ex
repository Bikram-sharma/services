defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller
  alias Services.Servicing

  def home(conn, _params) do

    render(conn, :home)
  end

end
