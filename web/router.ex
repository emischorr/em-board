defmodule EmBoard.Router do
  use EmBoard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    # plug :put_secure_browser_headers
    # plug :x_frame_header
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EmBoard do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmBoard do
  #   pipe_through :api
  # end


  defp x_frame_header(conn, _) do
    Plug.Conn.put_resp_header(conn, "X-Frame-Options", "ALLOW-FROM 10.1.50.160")
  end
end
