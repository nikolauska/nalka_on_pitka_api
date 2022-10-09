defmodule NalkaOnPitkaApiWeb.SiteController do
  use NalkaOnPitkaApiWeb, :controller

  alias NalkaOnPitkaApi.Sites

  def index(conn, _params) do
    conn
    |> Plug.Conn.put_status(200)
    |> json(Sites.get_sites())
  end

  def single(conn, %{"site" => site}) do
    if site in Sites.get_sites() do
      conn
      |> Plug.Conn.put_status(200)
      |> json(Sites.get(site))
    else
      conn
      |> Plug.Conn.put_status(404)
      |> json(%{ error: "Not a valid site" })
    end
  end
end
