defmodule Services.ServiceProviderTest do
  use Services.DataCase

  alias Services.ServiceProvider

  describe "service_provider" do
    alias Services.ServiceProvider.Provider

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.ServiceProviderFixtures

    @invalid_attrs %{bio: nil, years_of_experiance: nil, is_verified: nil}

    test "list_service_provider/1 returns all scoped service_provider" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_provider = provider_fixture(other_scope)
      assert ServiceProvider.list_service_provider(scope) == [provider]
      assert ServiceProvider.list_service_provider(other_scope) == [other_provider]
    end

    test "get_provider!/2 returns the provider with given id" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_scope = user_scope_fixture()
      assert ServiceProvider.get_provider!(scope, provider.id) == provider
      assert_raise Ecto.NoResultsError, fn -> ServiceProvider.get_provider!(other_scope, provider.id) end
    end

    test "create_provider/2 with valid data creates a provider" do
      valid_attrs = %{bio: "some bio", years_of_experiance: 42, is_verified: true}
      scope = user_scope_fixture()

      assert {:ok, %Provider{} = provider} = ServiceProvider.create_provider(scope, valid_attrs)
      assert provider.bio == "some bio"
      assert provider.years_of_experiance == 42
      assert provider.is_verified == true
      assert provider.user_id == scope.user.id
    end

    test "create_provider/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ServiceProvider.create_provider(scope, @invalid_attrs)
    end

    test "update_provider/3 with valid data updates the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      update_attrs = %{bio: "some updated bio", years_of_experiance: 43, is_verified: false}

      assert {:ok, %Provider{} = provider} = ServiceProvider.update_provider(scope, provider, update_attrs)
      assert provider.bio == "some updated bio"
      assert provider.years_of_experiance == 43
      assert provider.is_verified == false
    end

    test "update_provider/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)

      assert_raise MatchError, fn ->
        ServiceProvider.update_provider(other_scope, provider, %{})
      end
    end

    test "update_provider/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = ServiceProvider.update_provider(scope, provider, @invalid_attrs)
      assert provider == ServiceProvider.get_provider!(scope, provider.id)
    end

    test "delete_provider/2 deletes the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:ok, %Provider{}} = ServiceProvider.delete_provider(scope, provider)
      assert_raise Ecto.NoResultsError, fn -> ServiceProvider.get_provider!(scope, provider.id) end
    end

    test "delete_provider/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert_raise MatchError, fn -> ServiceProvider.delete_provider(other_scope, provider) end
    end

    test "change_provider/2 returns a provider changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert %Ecto.Changeset{} = ServiceProvider.change_provider(scope, provider)
    end
  end

  describe "service_providers" do
    alias Services.ServiceProvider.Provider

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.ServiceProviderFixtures

    @invalid_attrs %{bio: nil, years_of_experience: nil, is_verified: nil}

    test "list_service_providers/1 returns all scoped service_providers" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_provider = provider_fixture(other_scope)
      assert ServiceProvider.list_service_providers(scope) == [provider]
      assert ServiceProvider.list_service_providers(other_scope) == [other_provider]
    end

    test "get_provider!/2 returns the provider with given id" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_scope = user_scope_fixture()
      assert ServiceProvider.get_provider!(scope, provider.id) == provider
      assert_raise Ecto.NoResultsError, fn -> ServiceProvider.get_provider!(other_scope, provider.id) end
    end

    test "create_provider/2 with valid data creates a provider" do
      valid_attrs = %{bio: "some bio", years_of_experience: 42, is_verified: true}
      scope = user_scope_fixture()

      assert {:ok, %Provider{} = provider} = ServiceProvider.create_provider(scope, valid_attrs)
      assert provider.bio == "some bio"
      assert provider.years_of_experience == 42
      assert provider.is_verified == true
      assert provider.user_id == scope.user.id
    end

    test "create_provider/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ServiceProvider.create_provider(scope, @invalid_attrs)
    end

    test "update_provider/3 with valid data updates the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      update_attrs = %{bio: "some updated bio", years_of_experience: 43, is_verified: false}

      assert {:ok, %Provider{} = provider} = ServiceProvider.update_provider(scope, provider, update_attrs)
      assert provider.bio == "some updated bio"
      assert provider.years_of_experience == 43
      assert provider.is_verified == false
    end

    test "update_provider/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)

      assert_raise MatchError, fn ->
        ServiceProvider.update_provider(other_scope, provider, %{})
      end
    end

    test "update_provider/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = ServiceProvider.update_provider(scope, provider, @invalid_attrs)
      assert provider == ServiceProvider.get_provider!(scope, provider.id)
    end

    test "delete_provider/2 deletes the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:ok, %Provider{}} = ServiceProvider.delete_provider(scope, provider)
      assert_raise Ecto.NoResultsError, fn -> ServiceProvider.get_provider!(scope, provider.id) end
    end

    test "delete_provider/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert_raise MatchError, fn -> ServiceProvider.delete_provider(other_scope, provider) end
    end

    test "change_provider/2 returns a provider changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert %Ecto.Changeset{} = ServiceProvider.change_provider(scope, provider)
    end
  end
end
