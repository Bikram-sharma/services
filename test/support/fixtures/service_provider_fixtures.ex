defmodule Services.ServiceProviderFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.ServiceProvider` context.
  """

  @doc """
  Generate a provider.
  """
  def provider_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        bio: "some bio",
        is_verified: true,
        years_of_experience: 42
      })

    {:ok, provider} = Services.ServiceProvider.create_provider(scope, attrs)
    provider
  end
end
