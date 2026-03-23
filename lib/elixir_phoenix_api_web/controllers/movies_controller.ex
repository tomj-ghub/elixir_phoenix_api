defmodule ElixirPhoenixApiWeb.MoviesController do

  use ElixirPhoenixApiWeb, :controller

  alias ElixirPhoenixApi.Models.Movie
  alias ElixirPhoenixApi.Repo

  def getAll(conn, _params) do
    json(conn, %{message: "Hello World!"})
  end

  def createMovie(conn, %{"movie" => movie_params}) do
    changeset = Movie.changeset(%Movie{}, movie_params)

    case Repo.insert(changeset,
      on_conflict: [set: Map.to_list(movie_params)],
      conflict_target: [:title],
      returning: true) do

        {:ok, movie} ->
          conn
          |> put_status(:created)
          |> json(%{data: movie})

        {:error, changeset} ->
          
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: "something went wrong"})
    end
  end
end
