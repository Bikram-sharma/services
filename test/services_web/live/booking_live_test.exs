defmodule ServicesWeb.BookingLiveTest do
  use ServicesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Services.BookingsFixtures

  @create_attrs %{
    schedule_date_time: "2025-11-02T04:43:00Z",
    booked_at: "2025-11-02T04:43:00Z",
    cancelled_at: "2025-11-02T04:43:00Z",
    cancelled_by: "some cancelled_by",
    actual_total_price: "120.5",
    user_address: "some user_address"
  }
  @update_attrs %{
    schedule_date_time: "2025-11-03T04:43:00Z",
    booked_at: "2025-11-03T04:43:00Z",
    cancelled_at: "2025-11-03T04:43:00Z",
    cancelled_by: "some updated cancelled_by",
    actual_total_price: "456.7",
    user_address: "some updated user_address"
  }
  @invalid_attrs %{
    schedule_date_time: nil,
    booked_at: nil,
    cancelled_at: nil,
    cancelled_by: nil,
    actual_total_price: nil,
    user_address: nil
  }

  setup :register_and_log_in_user

  defp create_booking(%{scope: scope}) do
    booking = booking_fixture(scope)

    %{booking: booking}
  end

  describe "Index" do
    setup [:create_booking]

    test "lists all bookings", %{conn: conn, booking: booking} do
      {:ok, _index_live, html} = live(conn, ~p"/bookings")

      assert html =~ "Listing Bookings"
      assert html =~ booking.cancelled_by
    end

    test "saves new booking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/bookings")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Booking")
               |> render_click()
               |> follow_redirect(conn, ~p"/bookings/new")

      assert render(form_live) =~ "New Booking"

      assert form_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#booking-form", booking: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/bookings")

      html = render(index_live)
      assert html =~ "Booking created successfully"
      assert html =~ "some cancelled_by"
    end

    test "updates booking in listing", %{conn: conn, booking: booking} do
      {:ok, index_live, _html} = live(conn, ~p"/bookings")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#bookings-#{booking.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/bookings/#{booking}/edit")

      assert render(form_live) =~ "Edit Booking"

      assert form_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#booking-form", booking: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/bookings")

      html = render(index_live)
      assert html =~ "Booking updated successfully"
      assert html =~ "some updated cancelled_by"
    end

    test "deletes booking in listing", %{conn: conn, booking: booking} do
      {:ok, index_live, _html} = live(conn, ~p"/bookings")

      assert index_live |> element("#bookings-#{booking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bookings-#{booking.id}")
    end
  end

  describe "Show" do
    setup [:create_booking]

    test "displays booking", %{conn: conn, booking: booking} do
      {:ok, _show_live, html} = live(conn, ~p"/bookings/#{booking}")

      assert html =~ "Show Booking"
      assert html =~ booking.cancelled_by
    end

    test "updates booking and returns to show", %{conn: conn, booking: booking} do
      {:ok, show_live, _html} = live(conn, ~p"/bookings/#{booking}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/bookings/#{booking}/edit?return_to=show")

      assert render(form_live) =~ "Edit Booking"

      assert form_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#booking-form", booking: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/bookings/#{booking}")

      html = render(show_live)
      assert html =~ "Booking updated successfully"
      assert html =~ "some updated cancelled_by"
    end
  end
end
