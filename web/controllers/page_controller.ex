defmodule EmBoard.PageController do
  use EmBoard.Web, :controller
  alias EmBoard.Data

  def index(conn, _params) do
    {:ok, data} = Data.get
    render conn, "index.html", data: data
  end
end
