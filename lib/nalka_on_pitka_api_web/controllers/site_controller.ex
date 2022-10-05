defmodule NalkaOnPitkaApiWeb.SiteController do
  use NalkaOnPitkaApiWeb, :controller

  alias NalkaOnPitkaApi.Sites

  def index(conn, _params) do
    conn
    |> Plug.Conn.put_status(200)
    |> json(["harald"])
  end

  def single(conn, %{"site" => "harald"}) do
    conn
    |> Plug.Conn.put_status(200)
    |> json(Sites.get(Harald))
  end
end
