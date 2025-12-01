defmodule ServicesWeb.NotificationsLiveTest do
  use ServicesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Services.NotificationFixtures

  @create_attrs %{status: "some status", read: true, context: "some context", title: "some title", from: "some from", archived: true, favourite: true}
  @update_attrs %{status: "some updated status", read: false, context: "some updated context", title: "some updated title", from: "some updated from", archived: false, favourite: false}
  @invalid_attrs %{status: nil, read: false, context: nil, title: nil, from: nil, archived: false, favourite: false}

  setup :register_and_log_in_user

  defp create_notifications(%{scope: scope}) do
    notifications = notifications_fixture(scope)

    %{notifications: notifications}
  end

  describe "Index" do
    setup [:create_notifications]

    test "lists all notification", %{conn: conn, notifications: notifications} do
      {:ok, _index_live, html} = live(conn, ~p"/notification")

      assert html =~ "Listing Notification"
      assert html =~ notifications.title
    end

    test "saves new notifications", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notification")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Notifications")
               |> render_click()
               |> follow_redirect(conn, ~p"/notification/new")

      assert render(form_live) =~ "New Notifications"

      assert form_live
             |> form("#notifications-form", notifications: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#notifications-form", notifications: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notification")

      html = render(index_live)
      assert html =~ "Notifications created successfully"
      assert html =~ "some title"
    end

    test "updates notifications in listing", %{conn: conn, notifications: notifications} do
      {:ok, index_live, _html} = live(conn, ~p"/notification")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#notification-#{notifications.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notification/#{notifications}/edit")

      assert render(form_live) =~ "Edit Notifications"

      assert form_live
             |> form("#notifications-form", notifications: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#notifications-form", notifications: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notification")

      html = render(index_live)
      assert html =~ "Notifications updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes notifications in listing", %{conn: conn, notifications: notifications} do
      {:ok, index_live, _html} = live(conn, ~p"/notification")

      assert index_live |> element("#notification-#{notifications.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notification-#{notifications.id}")
    end
  end

  describe "Show" do
    setup [:create_notifications]

    test "displays notifications", %{conn: conn, notifications: notifications} do
      {:ok, _show_live, html} = live(conn, ~p"/notification/#{notifications}")

      assert html =~ "Show Notifications"
      assert html =~ notifications.title
    end

    test "updates notifications and returns to show", %{conn: conn, notifications: notifications} do
      {:ok, show_live, _html} = live(conn, ~p"/notification/#{notifications}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notification/#{notifications}/edit?return_to=show")

      assert render(form_live) =~ "Edit Notifications"

      assert form_live
             |> form("#notifications-form", notifications: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#notifications-form", notifications: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notification/#{notifications}")

      html = render(show_live)
      assert html =~ "Notifications updated successfully"
      assert html =~ "some updated title"
    end
  end
end
