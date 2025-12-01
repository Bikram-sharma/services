defmodule Services.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.Notifications` context.
  """
  @doc """
  Generate a special_notification.
  """
  def special_notification_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        archive: true,
        description: "some description",
        read: true
      })

    {:ok, special_notification} = Services.Notifications.create_special_notification(scope, attrs)
    special_notification
  end
end
