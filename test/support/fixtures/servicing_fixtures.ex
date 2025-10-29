defmodule Services.ServicingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.Servicing` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name"
      })

    {:ok, category} = Services.Servicing.create_category(scope, attrs)
    category
  end
end
