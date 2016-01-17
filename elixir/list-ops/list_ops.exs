defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count([]) do
    0
  end
  def count([_|t]) do
    1 + count(t)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    reverse(l, [])
  end
  def reverse([h|t], acc) do
    reverse(t, [h | acc])
  end
  def reverse([], acc) do
    acc
  end

  @spec map(list, (any -> any)) :: list
  def map([h|t], f) do
    [f.(h) | map(t, f)]
  end
  def map([], _) do
    []
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([h|t], f) do
    if f.(h), do: [h | filter(t, f)], else: filter(t, f)
  end
  def filter([], _) do
    []
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([h|t], acc, f) do
    reduce(t, f.(h, acc), f)
  end
  def reduce([], acc, _) do
    acc
  end

  @spec append(list, list) :: list
  def append(a, b) do
    prepend(reverse(a), b)
  end
  def prepend([h|t], b) do
    prepend(t, [h | b])
  end
  def prepend([], b) do
    b
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    concat(ll, [])
  end
  def concat([h|t], acc) do
    concat(t, prepend((if is_list(h), do: h, else: [h]), acc))
  end
  def concat([], acc) do
    acc |> reverse
  end

  # note to self: another solution for reverse (and other methods)
  # use guard clause for `[]` and handle the rest in a `case`
  def reverse2([]) do
    []
  end
  def reverse2([h|t], acc) do
    case {h, t} do
      {_, []} ->
        [h | acc]
      _ ->
        reverse2(t, [h | acc])
    end
  end
end
