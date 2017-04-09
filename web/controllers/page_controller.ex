defmodule WesleyanMenus.PageController do
  use WesleyanMenus.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
