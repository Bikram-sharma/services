defmodule Services.ServicingTest do
  use Services.DataCase

  alias Services.Servicing

  describe "categories" do
    alias Services.Servicing.Category

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.ServicingFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_categories/1 returns all scoped categories" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)
      other_category = category_fixture(other_scope)
      assert Servicing.list_categories(scope) == [category]
      assert Servicing.list_categories(other_scope) == [other_category]
    end

    test "get_category!/2 returns the category with given id" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      other_scope = user_scope_fixture()
      assert Servicing.get_category!(scope, category.id) == category
      assert_raise Ecto.NoResultsError, fn -> Servicing.get_category!(other_scope, category.id) end
    end

    test "create_category/2 with valid data creates a category" do
      valid_attrs = %{name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Category{} = category} = Servicing.create_category(scope, valid_attrs)
      assert category.name == "some name"
      assert category.description == "some description"
      assert category.user_id == scope.user.id
    end

    test "create_category/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Servicing.create_category(scope, @invalid_attrs)
    end

    test "update_category/3 with valid data updates the category" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Category{} = category} = Servicing.update_category(scope, category, update_attrs)
      assert category.name == "some updated name"
      assert category.description == "some updated description"
    end

    test "update_category/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)

      assert_raise MatchError, fn ->
        Servicing.update_category(other_scope, category, %{})
      end
    end

    test "update_category/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Servicing.update_category(scope, category, @invalid_attrs)
      assert category == Servicing.get_category!(scope, category.id)
    end

    test "delete_category/2 deletes the category" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      assert {:ok, %Category{}} = Servicing.delete_category(scope, category)
      assert_raise Ecto.NoResultsError, fn -> Servicing.get_category!(scope, category.id) end
    end

    test "delete_category/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)
      assert_raise MatchError, fn -> Servicing.delete_category(other_scope, category) end
    end

    test "change_category/2 returns a category changeset" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      assert %Ecto.Changeset{} = Servicing.change_category(scope, category)
    end
  end
end
