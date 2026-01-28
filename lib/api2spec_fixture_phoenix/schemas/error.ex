defmodule Api2specFixturePhoenix.Schemas.Error do
  @moduledoc """
  Schema representing an error response.
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :code, :string
    field :message, :string
    field :details, :map
  end
end
