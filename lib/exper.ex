defmodule Exper do
  @moduledoc """
  Exper keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

    def build_ordered_list_for_CSV( fields, single_map_record ) do
      fieldDataInOrder = Enum.map(fields, fn field ->
                                        valS = Map.get( single_map_record,field, nil)
                                        valS = "#{valS}"
                                        if String.at(valS, 0) == '"', do: valS, else: "\"" <> valS <> "\""
                                      end)

      fieldDataInOrder
  end

end
