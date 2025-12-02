defmodule ServicesWeb.SpecialNotificationLiveTest do
  use ServicesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Services.NotificationsFixtures

  @create_attrs %{read: true, archive: true, description: "some description"}
  @update_attrs %{read: false, archive: false, description: "some updated description"}
  @invalid_attrs %{read: false, archive: false, description: nil}

  setup :register_and_log_in_user

  defp create_special_notification(%{scope: scope}) do
    special_notification = special_notification_fixture(scope)

    %{special_notification: special_notification}
  end

  describe "Index" do
    setup [:create_special_notification]

    test "lists all special_notifications", %{
      conn: conn,
      special_notification: special_notification
    } do
      {:ok, _index_live, html} = live(conn, ~p"/special_notifications")

      assert html =~ "Listing Special notifications"
      assert html =~ special_notification.description
    end

    test "saves new special_notification", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/special_notifications")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Special notification")
               |> render_click()
               |> follow_redirect(conn, ~p"/special_notifications/new")

      assert render(form_live) =~ "New Special notification"

      assert form_live
             |> form("#special_notification-form", special_notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#special_notification-form", special_notification: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/special_notifications")

      html = render(index_live)
      assert html =~ "Special notification created successfully"
      assert html =~ "some description"
    end

    test "updates special_notification in listing", %{
      conn: conn,
      special_notification: special_notification
    } do
      {:ok, index_live, _html} = live(conn, ~p"/special_notifications")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#special_notifications-#{special_notification.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/special_notifications/#{special_notification}/edit")

      assert render(form_live) =~ "Edit Special notification"

      assert form_live
             |> form("#special_notification-form", special_notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#special_notification-form", special_notification: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/special_notifications")

      html = render(index_live)
      assert html =~ "Special notification updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes special_notification in listing", %{
      conn: conn,
      special_notification: special_notification
    } do
      {:ok, index_live, _html} = live(conn, ~p"/special_notifications")

      assert index_live
             |> element("#special_notifications-#{special_notification.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#special_notifications-#{special_notification.id}")
    end
  end

  describe "Show" do
    setup [:create_special_notification]

    test "displays special_notification", %{
      conn: conn,
      special_notification: special_notification
    } do
      {:ok, _show_live, html} = live(conn, ~p"/special_notifications/#{special_notification}")

      assert html =~ "Show Special notification"
      assert html =~ special_notification.description
    end

    test "updates special_notification and returns to show", %{
      conn: conn,
      special_notification: special_notification
    } do
      {:ok, show_live, _html} = live(conn, ~p"/special_notifications/#{special_notification}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/special_notifications/#{special_notification}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit Special notification"

      assert form_live
             |> form("#special_notification-form", special_notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#special_notification-form", special_notification: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/special_notifications/#{special_notification}")

      html = render(show_live)
      assert html =~ "Special notification updated successfully"
      assert html =~ "some updated description"
    end
  end
end
