defmodule Services.ProviderServiceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Services.ProviderService` context.
  """

  @doc """
  Generate a providers_service.
  """
  def providers_service_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        custom_price: "120.5",
        is_available: true
      })

    {:ok, providers_service} = Services.ProviderService.create_providers_service(scope, attrs)
    providers_service
  end
end
