defmodule Services.Service_providerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.Service_provider` context.
  """

  @doc """
  Generate a provider.
  """
  def provider_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        bio: "some bio",
        experience_year: 42,
        is_verified: true
      })

    {:ok, provider} = Services.Service_provider.create_provider(scope, attrs)
    provider
  end
end
