defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil
end

defmodule Zipper do
  alias BinTree, as: BT
  alias __MODULE__, as: Z

  @type trail :: :top
               | { :left, BT.t, trail }
               | { :right, BT.t, trail }

  @type t :: { BT.t, trail }

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    {bt, :top}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree({bt, :top}) do
    bt
  end
  def to_tree(z) do
    z |> up |> to_tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value({bt, _}) do
    bt.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left({%{left: left}, _}) when is_nil(left) do
    nil
  end
  def left({bt, trail}) do
    {bt.left, {:left, bt, trail}}
  end
  
  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right({%{right: right}, _}) when is_nil(right) do
    nil
  end
  def right({bt, trail}) do
    {bt.right, {:right, bt, trail}}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up({_, :top}) do
    nil
  end
  def up({_, {_, parent, trail}}) do
    {parent, trail}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(z, v) do
    update(z, v, :value)
  end
  
  @doc """
  Replace the left child tree of the focus node. 
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(z, l) do
    update(z, l, :left)
  end
  
  @doc """
  Replace the right child tree of the focus node. 
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(z, r) do
    update(z, r, :right)
  end

  @spec update(Z.t, any, {:left | :right | :value}) :: Z.t
  defp update({focus, :top}, value, property) do
    {focus |> Map.put(property, value), :top}
  end
  defp update({focus, {direction, parent, trail}}, value, property) do
    focus = focus |> Map.put(property, value)
    {_, parent} = parent |> Map.get_and_update(direction, fn(focus_in_parent) ->
      {focus_in_parent, focus}
    end)
    {focus, {direction, parent, trail}}
  end
end
