defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    #Agent.start_link(fn -> 0 end) |> elem(1)
    Agent.start_link(fn -> %{balance: 0} end) |> elem(1)
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    #Agent.get(account, &(&1))
    Agent.get(account, &Map.get(&1, :balance))
  end
 
  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    #Agent.update(account, &(&1 + amount))
    Agent.update(account, &Map.get_and_update(&1, :balance, fn(balance) ->
      {balance, balance + amount}
    end) |> elem(1))
  end
end
