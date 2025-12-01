defmodule Services.NotificationsTest do
  use Services.DataCase

  alias Services.Notifications

  describe "special_notifications" do
    alias Services.Notifications.SpecialNotification

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.NotificationsFixtures

    @invalid_attrs %{read: nil, archive: nil, description: nil}

    test "list_special_notifications/1 returns all scoped special_notifications" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      other_special_notification = special_notification_fixture(other_scope)
      assert Notifications.list_special_notifications(scope) == [special_notification]
      assert Notifications.list_special_notifications(other_scope) == [other_special_notification]
    end

    test "get_special_notification!/2 returns the special_notification with given id" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      other_scope = user_scope_fixture()
      assert Notifications.get_special_notification!(scope, special_notification.id) == special_notification
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_special_notification!(other_scope, special_notification.id) end
    end

    test "create_special_notification/2 with valid data creates a special_notification" do
      valid_attrs = %{read: "some read", archive: "some archive", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %SpecialNotification{} = special_notification} = Notifications.create_special_notification(scope, valid_attrs)
      assert special_notification.read == "some read"
      assert special_notification.archive == "some archive"
      assert special_notification.description == "some description"
      assert special_notification.user_id == scope.user.id
    end

    test "create_special_notification/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.create_special_notification(scope, @invalid_attrs)
    end

    test "update_special_notification/3 with valid data updates the special_notification" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      update_attrs = %{read: "some updated read", archive: "some updated archive", description: "some updated description"}

      assert {:ok, %SpecialNotification{} = special_notification} = Notifications.update_special_notification(scope, special_notification, update_attrs)
      assert special_notification.read == "some updated read"
      assert special_notification.archive == "some updated archive"
      assert special_notification.description == "some updated description"
    end

    test "update_special_notification/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)

      assert_raise MatchError, fn ->
        Notifications.update_special_notification(other_scope, special_notification, %{})
      end
    end

    test "update_special_notification/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Notifications.update_special_notification(scope, special_notification, @invalid_attrs)
      assert special_notification == Notifications.get_special_notification!(scope, special_notification.id)
    end

    test "delete_special_notification/2 deletes the special_notification" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert {:ok, %SpecialNotification{}} = Notifications.delete_special_notification(scope, special_notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_special_notification!(scope, special_notification.id) end
    end

    test "delete_special_notification/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert_raise MatchError, fn -> Notifications.delete_special_notification(other_scope, special_notification) end
    end

    test "change_special_notification/2 returns a special_notification changeset" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert %Ecto.Changeset{} = Notifications.change_special_notification(scope, special_notification)
    end
  end

  describe "special_notifications" do
    alias Services.Notifications.SpecialNotification

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.NotificationsFixtures

    @invalid_attrs %{read: nil, archive: nil, description: nil}

    test "list_special_notifications/1 returns all scoped special_notifications" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      other_special_notification = special_notification_fixture(other_scope)
      assert Notifications.list_special_notifications(scope) == [special_notification]
      assert Notifications.list_special_notifications(other_scope) == [other_special_notification]
    end

    test "get_special_notification!/2 returns the special_notification with given id" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      other_scope = user_scope_fixture()
      assert Notifications.get_special_notification!(scope, special_notification.id) == special_notification
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_special_notification!(other_scope, special_notification.id) end
    end

    test "create_special_notification/2 with valid data creates a special_notification" do
      valid_attrs = %{read: true, archive: true, description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %SpecialNotification{} = special_notification} = Notifications.create_special_notification(scope, valid_attrs)
      assert special_notification.read == true
      assert special_notification.archive == true
      assert special_notification.description == "some description"
      assert special_notification.user_id == scope.user.id
    end

    test "create_special_notification/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.create_special_notification(scope, @invalid_attrs)
    end

    test "update_special_notification/3 with valid data updates the special_notification" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      update_attrs = %{read: false, archive: false, description: "some updated description"}

      assert {:ok, %SpecialNotification{} = special_notification} = Notifications.update_special_notification(scope, special_notification, update_attrs)
      assert special_notification.read == false
      assert special_notification.archive == false
      assert special_notification.description == "some updated description"
    end

    test "update_special_notification/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)

      assert_raise MatchError, fn ->
        Notifications.update_special_notification(other_scope, special_notification, %{})
      end
    end

    test "update_special_notification/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Notifications.update_special_notification(scope, special_notification, @invalid_attrs)
      assert special_notification == Notifications.get_special_notification!(scope, special_notification.id)
    end

    test "delete_special_notification/2 deletes the special_notification" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert {:ok, %SpecialNotification{}} = Notifications.delete_special_notification(scope, special_notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_special_notification!(scope, special_notification.id) end
    end

    test "delete_special_notification/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert_raise MatchError, fn -> Notifications.delete_special_notification(other_scope, special_notification) end
    end

    test "change_special_notification/2 returns a special_notification changeset" do
      scope = user_scope_fixture()
      special_notification = special_notification_fixture(scope)
      assert %Ecto.Changeset{} = Notifications.change_special_notification(scope, special_notification)
    end
  end
end
