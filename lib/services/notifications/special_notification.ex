defmodule Services.Notifications.SpecialNotification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "special_notifications" do
    field :description, :string
    field :archive, :boolean, default: false
    field :read, :boolean, default: false

    belongs_to :bookings, Services.Bookings.Booking,
    foreign_key: :booking_id,
    type: :binary_id


    belongs_to :to_user, Services.Accounts.User,
    foreign_key: :to_id,
    type: :binary_id

    belongs_to :from_user, Services.Accounts.User,
    foreign_key: :user_id,
    type: :binary_id


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(special_notification, attrs, user_scope) do
    special_notification
    |> cast(attrs, [:description, :archive, :read, :to_id, :booking_id])
    |> validate_required([:description, :archive, :read, :to_id])
    |> put_change(:user_id, user_scope.user.id)
  end
  def changeset_update(special_notification, attrs, _user_scope) do
    special_notification
    |> cast(attrs, [:description, :archive, :read, :to_id, :booking_id, :user_id])
    |> validate_required([:description, :archive, :read, :to_id, :user_id])
  end
end
