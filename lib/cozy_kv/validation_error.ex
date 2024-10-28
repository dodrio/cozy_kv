defmodule CozyKV.ValidationError do
  @moduledoc """
  The error that is returned (or raised) when there is an issue in the
  validation process.

  ## Error message

  By default, the error struct doesn't include message.

  If you want to turn an error into a human-readable message, you should
  use `Exception.message/1`.

  If you don't like the default error message, you are free to customize your
  own version using the data provided by the error.
  """

  @type key :: term()
  @type type :: term()
  @type value :: term()

  @type unknown_keys :: {:unknown_keys, known_keys: [key()], unknown_keys: [key(), ...]}
  @type missing_key :: {:missing_key, required_key: key(), received_keys: [key()]}
  @type invalid_value :: {:invalid_value, key: key(), type: type(), value: value()}

  @type t :: %__MODULE__{
          path: [key()],
          type: unknown_keys() | missing_key() | invalid_value()
        }

  defexception [:message, type: nil, path: []]

  @impl true
  def message(%__MODULE__{type: type, path: path}) do
    suffix = " (under path #{inspect(path)})"
    to_message(type, path) <> suffix
  end

  defp to_message(
         {:unknown_keys, known_keys: known_keys, unknown_keys: unknown_keys},
         _path
       ) do
    "known keys are #{inspect(known_keys)}, " <>
      "but unknown keys #{inspect(unknown_keys)} are given."
  end

  defp to_message(
         {:missing_key, required_key: required_key, received_keys: received_keys},
         _path
       ) do
    "key #{inspect(required_key)} is required, " <>
      "but received keys #{inspect(received_keys)} don't include it."
  end
end