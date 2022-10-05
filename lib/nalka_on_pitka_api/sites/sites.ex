defmodule NalkaOnPitkaApi.Sites do
  @moduledoc """
  Get lunches for specified site
  """

  @sites [Harald]

  @doc """
  Get lunches
  """
  def get(site) when site in @sites do
    NalkaOnPitkaApi.Cache.get(Module.concat([NalkaOnPitkaApi, Sites, site]), :get)
  end
end
