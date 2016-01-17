defmodule HelloWorld do
  # Can you find a way to make all the tests pass with just one function?
  # Hint: look into argument defaults here:
  # http://elixir-lang.org/getting-started/modules.html#default-arguments

  def hello(name \\ "World") do
    "Hello, #{name}!"
  end
end
