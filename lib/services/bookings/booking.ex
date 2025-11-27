defmodule Services.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bookings" do
    field :schedule_date_time, :utc_datetime
    field :booked_at, :utc_datetime
    field :cancelled_at, :utc_datetime
    field :cancelled_by, :string
    field :actual_total_price, :decimal
    field :user_address, :string
    field :initiated_at, :utc_datetime
    field :booking_status, :string
    field :contact, :string
    field :payment_status, :string
    field :delivered_at, :utc_datetime
    field :accepted_at, :utc_datetime

    belongs_to :users, Services.Accounts.User,
      foreign_key: :user_id,
      type: :binary_id

    belongs_to :providers_service, Services.ProviderService.ProvidersService,
      foreign_key: :provider_service_id,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs, user_scope) do
    booking
    |> cast(attrs, [
      :schedule_date_time,
      :booked_at,
      :cancelled_at,
      :cancelled_by,
      :actual_total_price,
      :user_address
    ])
    |> validate_required([
      :schedule_date_time,
      :booked_at,
      :cancelled_at,
      :cancelled_by,
      :actual_total_price,
      :user_address
    ])
    |> put_change(:user_id, user_scope.user.id)
  end
end
