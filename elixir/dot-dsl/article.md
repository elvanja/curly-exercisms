Meta(sploit)ing Elixir
========================================

The last exercise from Exercism.io had to do with meta programming Elixir in disguise.
The task was an interesting one. You're supposed to write a custom DSL that supports Graphviz like language for building graphs.
So, one could write something like:

    graph
      graph [bgcolor="yellow"]
      a [color="red"]
      b [color="blue"]
      a -- b [color="green"]

and get back a graph structure

    Graph {
      attrs: [
        bgcolor: "yellow"
      ],
      nodes: [
        {:a, [color: "red"]},
        {:b, [color: "blue"]}
      ],
      edges: [
        {:a, :b, [color: "green"]}
      ]
    }

Cool! Essentially it will transform "simpler" DSL language to Graph structure defined as:

    defmodule Graph do
      defstruct attrs: [], nodes: [], edges: []
    end

Now, if there was only something we could generate the desired graph structure, but without having to write support for every node name, type etc. Elixir macros to the rescue! I tend to think about them as code that writes code, but for this case another aspect is far more important. Namely, when using macros, all the code that lands into macro is quoted. The official documentation offers some pretty detailed information, but it basically boils down to a simple facts:

- code is represented as a touple with specific structure that describes that code, that's the "quote"
- the quoted / described code is not evaluated at that time

Now this has some pretty nice implications. E.g. you can inspect all the code prior to deciding what to do with it, but also it prevents side effects from discarded code. You become the master of all code :D

Excellent, what now? Well, aside from quoted thingy protection, the tuple that quotes input code can be pattern matched. The structure is always:

{atom | tuple, list, list | atom}

Let's see how that relates to our graph DSL problem space. We have the following sentences:

graph [attributes]
node [nodes]
node -- other_node [attributes]

You can inspect those in iex, e.g. `quote do: c -- d [color: :blue]`. This results with: `{:--, [context: Elixir, import: Kernel], [{:c, [], Elixir}, {:d, [], [[color: :blue]]}]}`. As you can see, you can then create matching patterns like: `{:--, _, [{a, _, _}, {b, _, [attrs]}]}`. This pattern would match any relation with attributes, e.g. `a -- b [color: :blue]` or `a -- c [label: "meta!"]`. This little neat iex trick helps a lot, you can basically take any code and quote it, and see what is it actually made of. Kinda like Matrix, right?!

OK, so now we have our macro, we get the quoted graph DSL expression as argument, and we can pattern match parts of that quoted DSL to generate the desired output. So let's build that graph:

  defp build_graph({:graph, _, [attrs]}) do
    quote do: %Graph{attrs: unquote(attrs)}
  end

Two things happen here:

- returning quoted result
- unquoting values

With macros it's quite straight forward. You receive quoted code as attributes and you need to return quoted result back. Hence the `quote do:` in the above example.

Excellent, but what is that `unquote` thing? Well, it's a way to inject dynamic values into quoted expressions. You can think of it as evaluating quoted code and interpolating it in the result. In the above example. we've pattern matched a value, the attributes of a graph, and then used the `unquote` to evaluate them into the resulting graph structure.

So, now you know. Let's see a partial implementation of our graph DSL:

    defmodule Dot do
      defmacro graph(do: ast) do
        build_graph(ast)
      end

      defp build_graph({:__block__, _, graphs}) do
        graphs
        |> Enum.map(&(&1 |> build_graph |> Code.eval_quoted |> elem(0)))
        |> Enum.reduce(%Graph{}, &merge_graphs_sorted/2)
        |> Macro.escape
      end

      defp build_graph({:--, _, [{a, _, _}, {b, _, [attrs]}]}) do
        quote do: %Graph{edges: [{unquote(a), unquote(b), unquote(attrs)}]}
      end

      defp build_graph({:graph, _, [attrs]}) do
        quote do: %Graph{attrs: unquote(attrs)}
      end

      defp build_graph({node, _, [keywords]}) do
        quote do: %Graph{nodes: [{unquote(node), unquote(keywords)}]}
      end

      defp build_graph(_) do
        raise ArgumentError
      end
    end

Most of the code looks familiar, but there are a few tricks :)

`defmacro graph(do: ast)` is just a simplified way to parse a passing block to the macro. Let's compare the quoted input to macro, when invoking it with e.g. `Dot.graph do a [color: :green] end`:

- `[do: {:a, [line: 26], [[color: :green]]}]` - using `defmacro graph(ast)`
- `{:a, [line: 26], [[color: :green]]}` - using `defmacro graph(do: ast)`

The difference is obvious, we're just shortening our macro implementation.

`defp build_graph({:__block__, _, graphs}) do` is there for multiple lines of input to our graphs DSL. Essentially, Elixir tells us that a block has been passed in, that's the `:__block__` atom part. all the lines in the block are part of `graphs` pattern matched variable. As you can see in it's implementation, we're basically invoking `build_graph` per block line and merging the results.

`Code.eval_quoted` This one is used to evaluate the `build_graph` result, which is quoted of course. We need the resulting graph structure, so we can merge it into the resulting graph (the reduce section).

`Macro.escape` is finally used to create quoted result, because that's what we want to return from macro.

That is pretty much it. Working with macros is certainly not simple and follows it's own rules. Even official documentation warns agains abusing them too much, but they do have their place and certainly help with this kind of problems.


