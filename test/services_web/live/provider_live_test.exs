defmodule ServicesWeb.ProviderLiveTest do
  use ServicesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Services.Service_providerFixtures

  @create_attrs %{bio: "some bio", experience_year: 42, is_verified: true}
  @update_attrs %{bio: "some updated bio", experience_year: 43, is_verified: false}
  @invalid_attrs %{bio: nil, experience_year: nil, is_verified: false}

  setup :register_and_log_in_user

  defp create_provider(%{scope: scope}) do
    provider = provider_fixture(scope)

    %{provider: provider}
  end

  describe "Index" do
    setup [:create_provider]

    test "lists all provider", %{conn: conn, provider: provider} do
      {:ok, _index_live, html} = live(conn, ~p"/provider")

      assert html =~ "Listing Provider"
      assert html =~ provider.bio
    end

    test "saves new provider", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/provider")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Provider")
               |> render_click()
               |> follow_redirect(conn, ~p"/provider/new")

      assert render(form_live) =~ "New Provider"

      assert form_live
             |> form("#provider-form", provider: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#provider-form", provider: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/provider")

      html = render(index_live)
      assert html =~ "Provider created successfully"
      assert html =~ "some bio"
    end

    test "updates provider in listing", %{conn: conn, provider: provider} do
      {:ok, index_live, _html} = live(conn, ~p"/provider")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#provider-#{provider.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/provider/#{provider}/edit")

      assert render(form_live) =~ "Edit Provider"

      assert form_live
             |> form("#provider-form", provider: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#provider-form", provider: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/provider")

      html = render(index_live)
      assert html =~ "Provider updated successfully"
      assert html =~ "some updated bio"
    end

    test "deletes provider in listing", %{conn: conn, provider: provider} do
      {:ok, index_live, _html} = live(conn, ~p"/provider")

      assert index_live |> element("#provider-#{provider.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#provider-#{provider.id}")
    end
  end

  describe "Show" do
    setup [:create_provider]

    test "displays provider", %{conn: conn, provider: provider} do
      {:ok, _show_live, html} = live(conn, ~p"/provider/#{provider}")

      assert html =~ "Show Provider"
      assert html =~ provider.bio
    end

    test "updates provider and returns to show", %{conn: conn, provider: provider} do
      {:ok, show_live, _html} = live(conn, ~p"/provider/#{provider}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/provider/#{provider}/edit?return_to=show")

      assert render(form_live) =~ "Edit Provider"

      assert form_live
             |> form("#provider-form", provider: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#provider-form", provider: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/provider/#{provider}")

      html = render(show_live)
      assert html =~ "Provider updated successfully"
      assert html =~ "some updated bio"
    end
  end
end
