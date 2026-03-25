defmodule ElixirPhoenixApi.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do

    create table(:urls) do
      add :shortCode, :string, null: false
      add :shortUrl, :string, null: false

    timestamps()

    end
  end
end
