defmodule Services.RatingsTest do
  use Services.DataCase

  alias Services.Ratings

  describe "ratings" do
    alias Services.Ratings.Rating

    import Services.AccountsFixtures, only: [user_scope_fixture: 0]
    import Services.RatingsFixtures

    @invalid_attrs %{comment: nil, rating: nil}

    test "list_ratings/1 returns all scoped ratings" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)
      other_rating = rating_fixture(other_scope)
      assert Ratings.list_ratings(scope) == [rating]
      assert Ratings.list_ratings(other_scope) == [other_rating]
    end

    test "get_rating!/2 returns the rating with given id" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      other_scope = user_scope_fixture()
      assert Ratings.get_rating!(scope, rating.id) == rating
      assert_raise Ecto.NoResultsError, fn -> Ratings.get_rating!(other_scope, rating.id) end
    end

    test "create_rating/2 with valid data creates a rating" do
      valid_attrs = %{comment: "some comment", rating: 42}
      scope = user_scope_fixture()

      assert {:ok, %Rating{} = rating} = Ratings.create_rating(scope, valid_attrs)
      assert rating.comment == "some comment"
      assert rating.rating == 42
      assert rating.user_id == scope.user.id
    end

    test "create_rating/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Ratings.create_rating(scope, @invalid_attrs)
    end

    test "update_rating/3 with valid data updates the rating" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      update_attrs = %{comment: "some updated comment", rating: 43}

      assert {:ok, %Rating{} = rating} = Ratings.update_rating(scope, rating, update_attrs)
      assert rating.comment == "some updated comment"
      assert rating.rating == 43
    end

    test "update_rating/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)

      assert_raise MatchError, fn ->
        Ratings.update_rating(other_scope, rating, %{})
      end
    end

    test "update_rating/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Ratings.update_rating(scope, rating, @invalid_attrs)
      assert rating == Ratings.get_rating!(scope, rating.id)
    end

    test "delete_rating/2 deletes the rating" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert {:ok, %Rating{}} = Ratings.delete_rating(scope, rating)
      assert_raise Ecto.NoResultsError, fn -> Ratings.get_rating!(scope, rating.id) end
    end

    test "delete_rating/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert_raise MatchError, fn -> Ratings.delete_rating(other_scope, rating) end
    end

    test "change_rating/2 returns a rating changeset" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert %Ecto.Changeset{} = Ratings.change_rating(scope, rating)
    end
  end
end
