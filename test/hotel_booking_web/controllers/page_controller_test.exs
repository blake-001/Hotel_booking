defmodule HotelBookingWeb.PageControllerTest do
  use HotelBookingWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Booking · Confirmed"
  end
end
