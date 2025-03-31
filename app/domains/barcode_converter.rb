class BarcodeConverter
  def initialize(barcode)
    @barcode = barcode if barcode.match?(/^\d{12,13}$/)
    @query = barcode
    @toy_store = BarcodeManager::ToyStore.new(@barcode, @query)
    @reseller = BarcodeManager::Reseller.new(@barcode, @query)
  end

  def get_list_of_found_games
    toy_store_values = @toy_store.get_list_of_found_games
    reseller_values = @reseller.get_list_of_found_games
    [ toy_store_values, reseller_values ]
  end

  def convert
    raise StandardError if @barcode.nil? && @query.nil?

    toy_store_values, reseller_values = get_list_of_found_games

    # Si on a des valeurs des deux côtés, on cherche un match exact
    if toy_store_values && reseller_values
      toy_store_values[:values].each do |toy_game|
        reseller_values[:values].each do |reseller_game|
          if normalize_name(toy_game[:name]) == normalize_name(reseller_game[:name])
            return @reseller.convert(reseller_game[:callback_url])
          end
        end
      end
    end

    # Si on a plusieurs valeurs dans toy_store, on renvoie la liste
    if toy_store_values && toy_store_values[:values].size > 1
      return toy_store_values
    end

    # Si on a plusieurs valeurs dans reseller, on renvoie la liste
    if reseller_values && reseller_values[:values].size > 1
      return reseller_values
    end

    # Si aucune valeur n'est trouvée, on renvoie les deux résultats
    [ toy_store_values, reseller_values ].compact
  end

  def convert_with_converter(callback_url, converter_type)
    case converter_type
    when :toy_store
      @toy_store.convert(callback_url)
    when :reseller
      @reseller.convert(callback_url)
    else
      raise ArgumentError, "Type de convertisseur non supporté: #{converter_type}"
    end
  end

  private

  def normalize_name(name)
    return nil if name.nil?
    name.downcase
       .gsub(/[^a-z0-9\s]/, "") # Supprime les caractères spéciaux
       .gsub(/\s+/, " ")        # Remplace les espaces multiples par un seul
       .strip                    # Supprime les espaces au début et à la fin
  end
end
