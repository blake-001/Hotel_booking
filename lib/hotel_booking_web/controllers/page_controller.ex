defmodule HotelBookingWeb.PageController do
  use HotelBookingWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
