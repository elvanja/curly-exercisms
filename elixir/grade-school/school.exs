defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(Dict.t, String.t, pos_integer) :: Dict.t
  def add(db, name, grade) do
    #Map.put(db, grade, [name | if(db[grade], do: db[grade], else: [])])
    #Map.put(db, grade, [name | (if db[grade], do: db[grade], else: [])])
    Map.put(db, grade, [name | db[grade] || []])
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(Dict.t, pos_integer) :: [String]
  def grade(db, grade) do
    db[grade] || []
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(Dict) :: Dict.t
  def sort(db) do
    db |> Enum.reduce(%{}, fn({grade, names}, acc) ->
      Map.put(acc, grade, Enum.sort(names))
    end)
  end
end
