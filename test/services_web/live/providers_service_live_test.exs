defmodule ServicesWeb.ProvidersServiceLiveTest do
  use ServicesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Services.ProviderServiceFixtures

  @create_attrs %{custom_price: "120.5", is_available: true}
  @update_attrs %{custom_price: "456.7", is_available: false}
  @invalid_attrs %{custom_price: nil, is_available: false}

  setup :register_and_log_in_user

  defp create_providers_service(%{scope: scope}) do
    providers_service = providers_service_fixture(scope)

    %{providers_service: providers_service}
  end

  describe "Index" do
    setup [:create_providers_service]

    test "lists all providers_service", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/providers_service")

      assert html =~ "Listing Providers service"
    end

    test "saves new providers_service", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/providers_service")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Providers service")
               |> render_click()
               |> follow_redirect(conn, ~p"/providers_service/new")

      assert render(form_live) =~ "New Providers service"

      assert form_live
             |> form("#providers_service-form", providers_service: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#providers_service-form", providers_service: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/providers_service")

      html = render(index_live)
      assert html =~ "Providers service created successfully"
    end

    test "updates providers_service in listing", %{
      conn: conn,
      providers_service: providers_service
    } do
      {:ok, index_live, _html} = live(conn, ~p"/providers_service")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#providers_service-#{providers_service.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/providers_service/#{providers_service}/edit")

      assert render(form_live) =~ "Edit Providers service"

      assert form_live
             |> form("#providers_service-form", providers_service: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#providers_service-form", providers_service: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/providers_service")

      html = render(index_live)
      assert html =~ "Providers service updated successfully"
    end

    test "deletes providers_service in listing", %{
      conn: conn,
      providers_service: providers_service
    } do
      {:ok, index_live, _html} = live(conn, ~p"/providers_service")

      assert index_live
             |> element("#providers_service-#{providers_service.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#providers_service-#{providers_service.id}")
    end
  end

  describe "Show" do
    setup [:create_providers_service]

    test "displays providers_service", %{conn: conn, providers_service: providers_service} do
      {:ok, _show_live, html} = live(conn, ~p"/providers_service/#{providers_service}")

      assert html =~ "Show Providers service"
    end

    test "updates providers_service and returns to show", %{
      conn: conn,
      providers_service: providers_service
    } do
      {:ok, show_live, _html} = live(conn, ~p"/providers_service/#{providers_service}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/providers_service/#{providers_service}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit Providers service"

      assert form_live
             |> form("#providers_service-form", providers_service: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#providers_service-form", providers_service: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/providers_service/#{providers_service}")

      html = render(show_live)
      assert html =~ "Providers service updated successfully"
    end
  end
end
