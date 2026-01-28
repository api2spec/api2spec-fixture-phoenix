defmodule Api2specFixturePhoenix.Schemas.User do
  @moduledoc """
  Schema representing a user in the system.
  """
  use Ecto.Schema

  @primary_key {:id, :integer, autogenerate: false}
  embedded_schema do
    field :name, :string
    field :email, :string
    field :active, :boolean, default: true
    field :age, :integer
  end
end
