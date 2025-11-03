defmodule Services.BookingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.Bookings` context.
  """

  @doc """
  Generate a booking.
  """
  def booking_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        actual_total_price: "120.5",
        booked_at: ~U[2025-11-02 04:43:00Z],
        cancelled_at: ~U[2025-11-02 04:43:00Z],
        cancelled_by: "some cancelled_by",
        schedule_date_time: ~U[2025-11-02 04:43:00Z],
        user_address: "some user_address"
      })

    {:ok, booking} = Services.Bookings.create_booking(scope, attrs)
    booking
  end
end
