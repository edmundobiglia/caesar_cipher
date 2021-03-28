defmodule CaesarCipherTest do
  use ExUnit.Case
  doctest CaesarCipher

  setup do
    CaesarCipher.generate_cipher_map("t")
  end

  test "generates a cipher map when a correct offset is passed", %{cipher_map: result} do
    expected_result = %{
      "a" => "t",
      "b" => "u",
      "c" => "v",
      "d" => "w",
      "e" => "x",
      "f" => "y",
      "g" => "z",
      "h" => "a",
      "i" => "b",
      "j" => "c",
      "k" => "d",
      "l" => "e",
      "m" => "f",
      "n" => "g",
      "o" => "h",
      "p" => "i",
      "q" => "j",
      "r" => "k",
      "s" => "l",
      "t" => "m",
      "u" => "n",
      "v" => "o",
      "w" => "p",
      "x" => "q",
      "y" => "r",
      "z" => "s"
    }

    assert result == expected_result
  end

  test "returns error when not letter is passed" do
    result = CaesarCipher.generate_cipher_map(1)

    assert result == {:error, :should_be_a_letter}
  end
end
