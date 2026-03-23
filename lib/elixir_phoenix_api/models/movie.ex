defmodule ElixirPhoenixApi.Models.Movie do

  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :title, :year, :director]}

  #define a struct for movie
  schema "movies" do
    field :title, :string
    field :year, :integer
    field :director, :string

    timestamps()
  end

  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :year, :director])
    |> validate_required([:title, :year])
    |> unique_constraint(:title, name: :movies_title_index)
  end

end
