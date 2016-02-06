# Largest Series Product

Write a program that, when given a string of digits, can calculate the largest product for a series of consecutive digits of length n.

For example, for the input `'0123456789'`, the largest product for a
series of 3 digits is 504 (7 * 8 * 9), and the largest product for a
series of 5 digits is 15120 (5 * 6 * 7 * 8 * 9).

For the input `'73167176531330624919225119674426574742355349194934'`,
the largest product for a series of 6 digits is 23520.

## Running tests

Execute the tests with:

```bash
$ elixir bob_test.exs
```

(Replace `bob_test.exs` with the name of the test file.)


### Pending tests

In the test suites, all but the first test have been skipped.

Once you get a test passing, you can unskip the next one by
commenting out the relevant `@tag :pending` with a `#` symbol.

For example:

```elixir
# @tag :pending
test "shouting" do
  assert Bob.hey("WATCH OUT!") == "Whoa, chill out!"
end
```

Or, you can enable all the tests by commenting out the
`ExUnit.configure` line in the test suite.

```elixir
# ExUnit.configure exclude: :pending, trace: true
```

For more detailed information about the Elixir track, please
see the [help page](http://exercism.io/languages/elixir).

## Source

A variation on Problem 8 at Project Euler [view source](http://projecteuler.net/problem=8)
