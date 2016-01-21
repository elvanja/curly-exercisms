defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "3035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    case raw |> String.replace(~r/\W/, "") |> to_char_list do
      phone when length(phone) == 11 and hd(phone) == ?1 ->
        tl(phone)
      phone when length(phone) != 10 ->
        '0000000000'
      phone ->
        phone
    end |> to_string
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    raw |> number |> code
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    {code, prefix, line} = raw |> number |> split
    "(#{code}) #{prefix}-#{line}"
  end

  defp split(phone) do
    {code(phone), prefix(phone), line(phone)}
  end

  defp code(phone) do
    String.slice(phone, 0..2)
  end

  defp prefix(phone) do
    String.slice(phone, 3..5)
  end
  
  defp line(phone) do
    String.slice(phone, 6..-1)
  end
end
