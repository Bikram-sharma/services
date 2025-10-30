defmodule Services.ProviderServiceTest do
  use Services.DataCase

  alias Services.ProviderService

  describe "providers_service" do
    alias Services.ProviderService.ProvidersService

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.ProviderServiceFixtures

    @invalid_attrs %{custom_price: nil, is_available: nil}

    test "list_providers_service/1 returns all scoped providers_service" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      other_providers_service = providers_service_fixture(other_scope)
      assert ProviderService.list_providers_service(scope) == [providers_service]
      assert ProviderService.list_providers_service(other_scope) == [other_providers_service]
    end

    test "get_providers_service!/2 returns the providers_service with given id" do
      scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      other_scope = user_scope_fixture()
      assert ProviderService.get_providers_service!(scope, providers_service.id) == providers_service
      assert_raise Ecto.NoResultsError, fn -> ProviderService.get_providers_service!(other_scope, providers_service.id) end
    end

    test "create_providers_service/2 with valid data creates a providers_service" do
      valid_attrs = %{custom_price: "120.5", is_available: true}
      scope = user_scope_fixture()

      assert {:ok, %ProvidersService{} = providers_service} = ProviderService.create_providers_service(scope, valid_attrs)
      assert providers_service.custom_price == Decimal.new("120.5")
      assert providers_service.is_available == true
      assert providers_service.user_id == scope.user.id
    end

    test "create_providers_service/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ProviderService.create_providers_service(scope, @invalid_attrs)
    end

    test "update_providers_service/3 with valid data updates the providers_service" do
      scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      update_attrs = %{custom_price: "456.7", is_available: false}

      assert {:ok, %ProvidersService{} = providers_service} = ProviderService.update_providers_service(scope, providers_service, update_attrs)
      assert providers_service.custom_price == Decimal.new("456.7")
      assert providers_service.is_available == false
    end

    test "update_providers_service/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)

      assert_raise MatchError, fn ->
        ProviderService.update_providers_service(other_scope, providers_service, %{})
      end
    end

    test "update_providers_service/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = ProviderService.update_providers_service(scope, providers_service, @invalid_attrs)
      assert providers_service == ProviderService.get_providers_service!(scope, providers_service.id)
    end

    test "delete_providers_service/2 deletes the providers_service" do
      scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      assert {:ok, %ProvidersService{}} = ProviderService.delete_providers_service(scope, providers_service)
      assert_raise Ecto.NoResultsError, fn -> ProviderService.get_providers_service!(scope, providers_service.id) end
    end

    test "delete_providers_service/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      assert_raise MatchError, fn -> ProviderService.delete_providers_service(other_scope, providers_service) end
    end

    test "change_providers_service/2 returns a providers_service changeset" do
      scope = user_scope_fixture()
      providers_service = providers_service_fixture(scope)
      assert %Ecto.Changeset{} = ProviderService.change_providers_service(scope, providers_service)
    end
  end
end
