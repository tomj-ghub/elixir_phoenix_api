defmodule ElixirPhoenixApiWeb.MoviesController do

  use ElixirPhoenixApiWeb, :controller

  alias ElixirPhoenixApi.Models.Movie
  alias ElixirPhoenixApi.Repo

  def getOne(conn, %{"id" => id}) do
    movie = Repo.get(Movie, id)
    json(conn, %{data: movie})
  end

  def getAll(conn, _params) do
    movies = Repo.all(Movie)
    json(conn, %{data: movies})
  end

  def upsertMovie(conn, %{"movie" => movie_params}) do
    changeset = Movie.changeset(%Movie{}, movie_params)

    #taj temp
    atom_params =
      movie_params
      |> Enum.map(fn {k, v} ->
        {String.to_existing_atom(k),v}
      end)

    case Repo.insert(changeset,
      #on_conflict: [set: Map.to_list(movie_params)],
      on_conflict: [set: atom_params],
      conflict_target: [:title],
      returning: true) do

        {:ok, movie} ->
          conn
          |> put_status(:created)
          |> json(%{data: movie})

        {:error, _changeset} ->

          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: "something went wrong"})
    end
  end

  def deleteOne(conn, %{"id" => id}) do
    case Repo.get(Movie, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Movie Not Found"})
      movie ->
        case Repo.delete(movie) do
          {:ok, _changeset} ->
            conn
            |> put_status(:ok)
            |> json(%{data: "Success"})
          {:error, :changeset} ->
            conn
            |> put_status(:unproccessed_entity)
            |> json(%{error: "unable to delete"})
        end
    end
  end
end
