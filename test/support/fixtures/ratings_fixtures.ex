defmodule Services.RatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.Ratings` context.
  """

  @doc """
  Generate a rating.
  """
  def rating_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        comment: "some comment",
        rating: 42
      })

    {:ok, rating} = Services.Ratings.create_rating(scope, attrs)
    rating
  end
end
