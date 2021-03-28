defmodule CaesarCipher do
  @spec encrypt(binary, binary) :: tuple()
  def encrypt(sentence, offset) when is_binary(sentence) and is_binary(offset) do
    normalized_sentence = normalize_sentence(sentence)

    cipher_map = generate_cipher_map(String.downcase(offset))

    encrypted_message =
      normalized_sentence
      |> Enum.reduce("", fn
        " ", partial_sentence -> partial_sentence <> " "
        character, partial_sentence -> partial_sentence <> cipher_map[character]
      end)

    {:ok, encrypted_message}
  end

  @spec decrypt(binary, binary) :: tuple()
  def decrypt(sentence, offset) when is_binary(sentence) and is_binary(offset) do
    normalized_sentence = normalize_sentence(sentence)

    cipher_map = generate_cipher_map(String.downcase(offset), :decrypt)

    decrypted_message =
      normalized_sentence
      |> Enum.reduce("", fn
        " ", partial_sentence -> partial_sentence <> " "
        character, partial_sentence -> partial_sentence <> cipher_map[character]
      end)

    {:ok, decrypted_message}
  end

  defp normalize_sentence(sentence) do
    sentence
    |> String.downcase()
    |> String.replace(~r/[\p{P}\p{S}]/u, "")
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.split("", trim: true)
  end

  defp generate_cipher_map(offset) when is_binary(offset) do
    initial_map = initialize_cipher_map()

    cipher = generate_cipher(offset)

    cipher_list = cipher |> String.split("", trim: true)

    %{cipher_map: cipher_map} =
      initial_map
      |> Enum.reduce(
        %{cipher_map: %{}, index: 0},
        fn {letter, _cipher}, %{cipher_map: cipher_map, index: index} when index < 26 ->
          updated_map = Map.put(cipher_map, letter, Enum.at(cipher_list, index))

          %{cipher_map: updated_map, index: index + 1}
        end
      )

    cipher_map
  end

  defp generate_cipher_map(offset, :decrypt) when is_binary(offset) do
    cipher = generate_cipher(offset)

    initial_map = initialize_cipher_map(cipher)

    cipher_list = "abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true)

    %{cipher_map: cipher_map} =
      initial_map
      |> Enum.reduce(
        %{cipher_map: %{}, index: 0},
        fn {letter, _cipher}, %{cipher_map: cipher_map, index: index} when index < 26 ->
          updated_map = Map.put(cipher_map, letter, Enum.at(cipher_list, index))

          %{cipher_map: updated_map, index: index + 1}
        end
      )

    cipher_map
  end

  defp generate_cipher(offset) do
    alphabet = "abcdefghijklmnopqrstuvwxyz"

    {offset_index, _length} = alphabet |> :binary.match(offset)

    <<head::binary-size(offset_index), tail::binary>> = alphabet

    cipher = tail <> head

    cipher
  end

  defp initialize_cipher_map(cipher \\ "abcdefghijklmnopqrstuvwxyz") do
    letter_list = cipher |> String.split("", trim: true)

    cipher_map =
      letter_list
      |> Enum.reduce([], fn letter, acc ->
        acc ++ [{letter, nil}]
      end)

    cipher_map
  end
end
