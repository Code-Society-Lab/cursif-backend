defmodule CursifWeb.Middlewares.SafeResolution do
  @moduledoc """
  This module is a wrapper for `Absinthe.Resolution` middleware to gracefully handle
  exceptions raised during the execution.

  This solution is from https://shyr.io/blog/absinthe-exception-error-handling
  """
  alias Absinthe.Resolution
  require Logger

  @behaviour Absinthe.Middleware
  @default_error {:error, :unknown}


  # Replacement Helper
  # ------------------

  @doc """
  Call this on existing middleware to replace instances of
  `Resolution` middleware with `SafeResolution`
  """
  @spec apply(list()) :: list()
  def apply(middleware) when is_list(middleware) do
    Enum.map(middleware, fn
      {{Resolution, :call}, resolver} -> {__MODULE__, resolver}
      other -> other
    end)
  end


  # Middleware Callbacks
  # --------------------

  @impl true
  def call(resolution, resolver) do
    Resolution.call(resolution, resolver)
  rescue
    exception ->
      error = Exception.format(:error, exception, __STACKTRACE__)
      Logger.error(error)
      Resolution.put_result(resolution, @default_error)
  end
end