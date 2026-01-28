defmodule Api2specFixturePhoenix.Schemas.Post do
  @moduledoc """
  Schema representing a blog post.
  """
  use Ecto.Schema

  @primary_key {:id, :integer, autogenerate: false}
  embedded_schema do
    field :title, :string
    field :body, :string
    field :published, :boolean, default: false
    field :view_count, :integer, default: 0
    field :user_id, :integer
  end
end
