defmodule Services.Notifications.SpecialNotification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "special_notifications" do
    field :description, :string
    field :archive, :boolean, default: false
    field :read, :boolean, default: false
    field :booking_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(special_notification, attrs, user_scope) do
    special_notification
    |> cast(attrs, [:description, :archive, :read, :booking_id])
    |> validate_required([:description, :archive, :read])
    |> put_change(:user_id, user_scope.user.id)
  end
end
