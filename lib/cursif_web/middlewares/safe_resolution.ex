defmodule CursifWeb.Middlewares.SafeResolution do
  @moduledoc """
  This module is a wrapper for `Absinthe.Resolution` middleware to gracefully handle
  exceptions raised during the execution.

  Additionnaly, this middleware automatically adds `CursifWeb.Middlewares.ErrorHandler`.

  Based on https://shyr.io/blog/absinthe-exception-error-handling
  """
  alias Absinthe.Resolution
  alias CursifWeb.Middlewares.ErrorHandler

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
    Enum.map((middleware ++ [ErrorHandler]), fn
      {{Resolution, :call}, resolver} -> {__MODULE__, resolver}
      other -> other
    end)
  end


  # Middleware Callbacks
  # --------------------

  @impl true
  def call(resolution, resolver) do
    Resolution.call(resolution, resolver)
  rescue exception ->
    Logger.error(Exception.format(:error, exception, __STACKTRACE__))
    handle_exception(resolution, exception)
  end

  defp handle_exception(resolution, %Ecto.NoResultsError{}),
    do: Resolution.put_result(resolution, {:error, :not_found})

  defp handle_exception(resolution, _exception),
    do: Resolution.put_result(resolution, @default_error)
end