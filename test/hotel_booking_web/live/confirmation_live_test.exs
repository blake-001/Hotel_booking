defmodule HotelBookingWeb.ConfirmationLiveTest do
  use HotelBookingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "confirmation actions render alongside the booking heading", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#confirmation-header")
    assert has_element?(view, "#confirmation-status", "Booking · Confirmed")
    assert has_element?(view, "#print-receipt[phx-click]")
    assert has_element?(view, "#add-to-calendar")
    assert has_element?(view, "#confirmation-actions.flex")
    assert has_element?(view, "#print-receipt.flex-1")
    assert has_element?(view, "#add-to-calendar.flex-1")
  end

  test "stay details render all three cards and Wi-Fi credentials", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#stay-details")
    assert has_element?(view, "#arrival-card")
    assert has_element?(view, "#wifi-card")
    assert has_element?(view, "#wifi-card", "Muhembo")
    assert has_element?(view, "#copy-wifi[phx-hook='CopyText']")
    assert has_element?(view, "#breakfast-card")
  end

  test "booking summary renders the receipt and personalized welcome cards", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#booking-summary")
    assert has_element?(view, "#receipt-card", "MS-2026 0421-AH")
    assert has_element?(view, "#receipt-card", "€ 730.40")
    assert has_element?(view, "#receipt-card", "Tourist tax")
    assert has_element?(view, "#welcome-card", "Ngumbao.")
    assert has_element?(view, "#welcome-card", "Tsavo")
  end

  test "mobile navigation is collapsed and can be toggled", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#menu-btn[aria-expanded='false']")
    assert has_element?(view, "#sidebar-panel.hidden")

    view
    |> element("#menu-btn")
    |> render_click()

    assert has_element?(view, "#menu-btn[aria-expanded='true']")
    assert has_element?(view, "#sidebar-panel:not(.hidden)")

    view
    |> element("#menu-btn")
    |> render_click()

    assert has_element?(view, "#menu-btn[aria-expanded='false']")
    assert has_element?(view, "#sidebar-panel.hidden")
  end
end
