defmodule Services.BookingsTest do
  use Services.DataCase

  alias Services.Bookings

  describe "bookings" do
    alias Services.Bookings.Booking

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.BookingsFixtures

    @invalid_attrs %{schedule_date_time: nil, booked_at: nil, cancelled_at: nil, cancelled_by: nil, actual_total_price: nil, user_address: nil}

    test "list_bookings/1 returns all scoped bookings" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      booking = booking_fixture(scope)
      other_booking = booking_fixture(other_scope)
      assert Bookings.list_bookings(scope) == [booking]
      assert Bookings.list_bookings(other_scope) == [other_booking]
    end

    test "get_booking!/2 returns the booking with given id" do
      scope = user_scope_fixture()
      booking = booking_fixture(scope)
      other_scope = user_scope_fixture()
      assert Bookings.get_booking!(scope, booking.id) == booking
      assert_raise Ecto.NoResultsError, fn -> Bookings.get_booking!(other_scope, booking.id) end
    end

    test "create_booking/2 with valid data creates a booking" do
      valid_attrs = %{schedule_date_time: ~U[2025-11-02 04:43:00Z], booked_at: ~U[2025-11-02 04:43:00Z], cancelled_at: ~U[2025-11-02 04:43:00Z], cancelled_by: "some cancelled_by", actual_total_price: "120.5", user_address: "some user_address"}
      scope = user_scope_fixture()

      assert {:ok, %Booking{} = booking} = Bookings.create_booking(scope, valid_attrs)
      assert booking.schedule_date_time == ~U[2025-11-02 04:43:00Z]
      assert booking.booked_at == ~U[2025-11-02 04:43:00Z]
      assert booking.cancelled_at == ~U[2025-11-02 04:43:00Z]
      assert booking.cancelled_by == "some cancelled_by"
      assert booking.actual_total_price == Decimal.new("120.5")
      assert booking.user_address == "some user_address"
      assert booking.user_id == scope.user.id
    end

    test "create_booking/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookings.create_booking(scope, @invalid_attrs)
    end

    test "update_booking/3 with valid data updates the booking" do
      scope = user_scope_fixture()
      booking = booking_fixture(scope)
      update_attrs = %{schedule_date_time: ~U[2025-11-03 04:43:00Z], booked_at: ~U[2025-11-03 04:43:00Z], cancelled_at: ~U[2025-11-03 04:43:00Z], cancelled_by: "some updated cancelled_by", actual_total_price: "456.7", user_address: "some updated user_address"}

      assert {:ok, %Booking{} = booking} = Bookings.update_booking(scope, booking, update_attrs)
      assert booking.schedule_date_time == ~U[2025-11-03 04:43:00Z]
      assert booking.booked_at == ~U[2025-11-03 04:43:00Z]
      assert booking.cancelled_at == ~U[2025-11-03 04:43:00Z]
      assert booking.cancelled_by == "some updated cancelled_by"
      assert booking.actual_total_price == Decimal.new("456.7")
      assert booking.user_address == "some updated user_address"
    end

    test "update_booking/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      booking = booking_fixture(scope)

      assert_raise MatchError, fn ->
        Bookings.update_booking(other_scope, booking, %{})
      end
    end

    test "update_booking/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      booking = booking_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Bookings.update_booking(scope, booking, @invalid_attrs)
      assert booking == Bookings.get_booking!(scope, booking.id)
    end

    test "delete_booking/2 deletes the booking" do
      scope = user_scope_fixture()
      booking = booking_fixture(scope)
      assert {:ok, %Booking{}} = Bookings.delete_booking(scope, booking)
      assert_raise Ecto.NoResultsError, fn -> Bookings.get_booking!(scope, booking.id) end
    end

    test "delete_booking/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      booking = booking_fixture(scope)
      assert_raise MatchError, fn -> Bookings.delete_booking(other_scope, booking) end
    end

    test "change_booking/2 returns a booking changeset" do
      scope = user_scope_fixture()
      booking = booking_fixture(scope)
      assert %Ecto.Changeset{} = Bookings.change_booking(scope, booking)
    end
  end
end
