defmodule ElixirPhoenixApi.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string, null: false
      add :year, :integer, null: false
      add :director, :string

      timestamps()
    end

    create index(:movies, [:title], name: :movies_title_index)

  end
end
