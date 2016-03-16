defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph(do: ast) do
    build_graph(ast)
  end

  defp build_graph({:__block__, _, graphs}) do
    graphs
    |> Enum.map(&(&1 |> build_graph |> Code.eval_quoted |> elem(0)))
    |> Enum.reduce(%Graph{}, fn(graph, acc) ->
      graph |> Map.merge(acc, fn(k, v1, v2) ->
        if k == :__struct__ do
          v1
        else
          v1 ++ v2 |> Enum.sort
        end
      end) 
    end)
    |> Macro.escape
  end

  defp build_graph({:--, _, [{a, _, _}, {b, _, nil}]}) do
    quote do: %Graph{edges: [{unquote(a), unquote(b), []}]}
  end

  defp build_graph({:--, _, [{a, _, _}, {b, _, [attrs]}]}) do
    if Macro.escape(attrs) != attrs do; raise ArgumentError end
    quote do: %Graph{edges: [{unquote(a), unquote(b), unquote(attrs)}]}
  end

  defp build_graph({:graph, _, [attrs]}) do
    if Macro.escape(attrs) != attrs do; raise ArgumentError end
    quote do: %Graph{attrs: unquote(attrs)}
  end

  defp build_graph({key, _, nil}) do
    quote do: %Graph{nodes: [{unquote(key), []}]}
  end

  defp build_graph({key, _, [nodes]}) do
    if Macro.escape(nodes) != nodes do; raise ArgumentError end
    quote do: %Graph{nodes: [{unquote(key), unquote(nodes)}]}
  end

  defp build_graph(nil) do
    quote do: %Graph{}
  end

  defp build_graph(_) do
    raise ArgumentError
  end
end
