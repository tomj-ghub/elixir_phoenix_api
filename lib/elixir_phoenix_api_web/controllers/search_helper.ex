defmodule ElixirPhoenixApiWeb.SearchHelper do

  def compute_distance(word1, word2) do

    w1 = String.graphemes(word1)
    w2 = String.graphemes(word2)

    initRow = Enum.to_list(0..length(w1) + 1)
    Enum.reduce(w2, [initRow], fn currentChar, acc ->
      prevRow = List.last(acc)
      newRow = build_row(currentChar, prevRow, w1)
      acc ++ [newRow]
    end)

  end

  defp build_row(currentChar, prevRow, w1) do
    initialCell = List.first(prevRow) + 1

    Enum.reduce(1..length(w1), [initialCell], fn j, rowAcc ->
      cost = if currentChar == Enum.at(w1, j - 1), do: 0, else: 1

      deletion = Enum.at(prevRow, j) + 1
      insertion = List.last(rowAcc) + 1
      substitution = Enum.at(prevRow, j - 1) + cost

      newCost = min(deletion, min(insertion, substitution))
      rowAcc ++ [newCost]
    end)
  end
end
