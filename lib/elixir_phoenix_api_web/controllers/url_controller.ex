defmodule ElixirPhoenixApiWeb.UrlController do

  use ElixirPhoenixApiWeb, :controller

  alias ElixirPhoenixApi.Models.Url
  alias ElixirPhoenixApi.Repo

  import Ecto.Query

  def shorten(conn, %{"url" => incomingUrl}) do
    charset = ~c"BCDFGHJKLMNPQRSTVWXYZ0123456789"
    random = Enum.take_random(charset, 10) |> to_string()
    fullUrl = ElixirPhoenixApiWeb.Endpoint.url() <> "/" <> random
    changeset = Url.changeset(%Url{}, %{shortCode: random, shortUrl: incomingUrl})

    case Repo.insert(changeset,
      returning: true) do

        {:ok, _opts} ->
          conn
          |> put_status(:created)
          |> json(%{shortCode: random,
                    shortUrl: fullUrl})

        {:error, _opts} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: "something went wrong"})
      end
    end

    def getShort(conn, %{"shortUrl" => shortUrl}) do
      query = from u in Url,
          where: u.shortCode == ^shortUrl,
          select: u
      case Repo.one(query) do
        nil ->
          conn
          |> put_status(:not_found)

        url ->
          conn
          |> redirect(external: url.shortUrl)
        end
    end

end
