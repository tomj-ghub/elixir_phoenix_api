defmodule ElixirPhoenixApi.Models.Url do

  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:shortCode, :shortUrl]}

  #define a struct for movie
  schema "urls" do
    field :shortCode, :string
    field :shortUrl, :string

    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs, [:shortCode, :shortUrl])
    |> validate_required([:shortCode, :shortUrl])
  end

end
