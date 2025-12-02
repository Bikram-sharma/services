defmodule Services.NotificationTest do
  use Services.DataCase

  alias Services.Notification

  describe "notification" do
    alias Services.Notification.Notifications

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.NotificationFixtures

    @invalid_attrs %{
      status: nil,
      read: nil,
      context: nil,
      title: nil,
      from: nil,
      archived: nil,
      favourite: nil
    }

    test "list_notification/1 returns all scoped notification" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notifications = notifications_fixture(scope)
      other_notifications = notifications_fixture(other_scope)
      assert Notification.list_notification(scope) == [notifications]
      assert Notification.list_notification(other_scope) == [other_notifications]
    end

    test "get_notifications!/2 returns the notifications with given id" do
      scope = user_scope_fixture()
      notifications = notifications_fixture(scope)
      other_scope = user_scope_fixture()
      assert Notification.get_notifications!(scope, notifications.id) == notifications

      assert_raise Ecto.NoResultsError, fn ->
        Notification.get_notifications!(other_scope, notifications.id)
      end
    end

    test "create_notifications/2 with valid data creates a notifications" do
      valid_attrs = %{
        status: "some status",
        read: true,
        context: "some context",
        title: "some title",
        from: "some from",
        archived: true,
        favourite: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Notifications{} = notifications} =
               Notification.create_notifications(scope, valid_attrs)

      assert notifications.status == "some status"
      assert notifications.read == true
      assert notifications.context == "some context"
      assert notifications.title == "some title"
      assert notifications.from == "some from"
      assert notifications.archived == true
      assert notifications.favourite == true
      assert notifications.user_id == scope.user.id
    end

    test "create_notifications/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Notification.create_notifications(scope, @invalid_attrs)
    end

    test "update_notifications/3 with valid data updates the notifications" do
      scope = user_scope_fixture()
      notifications = notifications_fixture(scope)

      update_attrs = %{
        status: "some updated status",
        read: false,
        context: "some updated context",
        title: "some updated title",
        from: "some updated from",
        archived: false,
        favourite: false
      }

      assert {:ok, %Notifications{} = notifications} =
               Notification.update_notifications(scope, notifications, update_attrs)

      assert notifications.status == "some updated status"
      assert notifications.read == false
      assert notifications.context == "some updated context"
      assert notifications.title == "some updated title"
      assert notifications.from == "some updated from"
      assert notifications.archived == false
      assert notifications.favourite == false
    end

    test "update_notifications/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notifications = notifications_fixture(scope)

      assert_raise MatchError, fn ->
        Notification.update_notifications(other_scope, notifications, %{})
      end
    end

    test "update_notifications/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      notifications = notifications_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Notification.update_notifications(scope, notifications, @invalid_attrs)

      assert notifications == Notification.get_notifications!(scope, notifications.id)
    end

    test "delete_notifications/2 deletes the notifications" do
      scope = user_scope_fixture()
      notifications = notifications_fixture(scope)
      assert {:ok, %Notifications{}} = Notification.delete_notifications(scope, notifications)

      assert_raise Ecto.NoResultsError, fn ->
        Notification.get_notifications!(scope, notifications.id)
      end
    end

    test "delete_notifications/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      notifications = notifications_fixture(scope)

      assert_raise MatchError, fn ->
        Notification.delete_notifications(other_scope, notifications)
      end
    end

    test "change_notifications/2 returns a notifications changeset" do
      scope = user_scope_fixture()
      notifications = notifications_fixture(scope)
      assert %Ecto.Changeset{} = Notification.change_notifications(scope, notifications)
    end
  end
end
