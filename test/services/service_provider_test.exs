defmodule Services.Service_providerTest do
  use Services.DataCase

  alias Services.Service_provider

  describe "provider" do
    alias Services.Service_provider.Provider

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.Service_providerFixtures

    @invalid_attrs %{bio: nil, experience_year: nil, is_verified: nil}

    test "list_provider/1 returns all scoped provider" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_provider = provider_fixture(other_scope)
      assert Service_provider.list_provider(scope) == [provider]
      assert Service_provider.list_provider(other_scope) == [other_provider]
    end

    test "get_provider!/2 returns the provider with given id" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      other_scope = user_scope_fixture()
      assert Service_provider.get_provider!(scope, provider.id) == provider
      assert_raise Ecto.NoResultsError, fn -> Service_provider.get_provider!(other_scope, provider.id) end
    end

    test "create_provider/2 with valid data creates a provider" do
      valid_attrs = %{bio: "some bio", experience_year: 42, is_verified: true}
      scope = user_scope_fixture()

      assert {:ok, %Provider{} = provider} = Service_provider.create_provider(scope, valid_attrs)
      assert provider.bio == "some bio"
      assert provider.experience_year == 42
      assert provider.is_verified == true
      assert provider.user_id == scope.user.id
    end

    test "create_provider/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Service_provider.create_provider(scope, @invalid_attrs)
    end

    test "update_provider/3 with valid data updates the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      update_attrs = %{bio: "some updated bio", experience_year: 43, is_verified: false}

      assert {:ok, %Provider{} = provider} = Service_provider.update_provider(scope, provider, update_attrs)
      assert provider.bio == "some updated bio"
      assert provider.experience_year == 43
      assert provider.is_verified == false
    end

    test "update_provider/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)

      assert_raise MatchError, fn ->
        Service_provider.update_provider(other_scope, provider, %{})
      end
    end

    test "update_provider/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Service_provider.update_provider(scope, provider, @invalid_attrs)
      assert provider == Service_provider.get_provider!(scope, provider.id)
    end

    test "delete_provider/2 deletes the provider" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert {:ok, %Provider{}} = Service_provider.delete_provider(scope, provider)
      assert_raise Ecto.NoResultsError, fn -> Service_provider.get_provider!(scope, provider.id) end
    end

    test "delete_provider/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert_raise MatchError, fn -> Service_provider.delete_provider(other_scope, provider) end
    end

    test "change_provider/2 returns a provider changeset" do
      scope = user_scope_fixture()
      provider = provider_fixture(scope)
      assert %Ecto.Changeset{} = Service_provider.change_provider(scope, provider)
    end
  end
end
