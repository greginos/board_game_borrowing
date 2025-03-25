class BarcodeConverterToyStore
  def initialize(barcode)
    @barcode = barcode
  end

  def convert
    raise StandardError if @barcode.nil?
    boardgame = BoardGame.find_by(ean: @barcode)
    return boardgame unless boardgame.nil?

    get_game_infos
  end

  def fill_image
    board_game = BoardGame.find_by(ean: @barcode)
    values = get_game_infos(@barcode)
    if values.nil?
      values = get_game_infos(board_game.name)
    end
    board_game.update(image_link: values[:image_link]) unless values[:image_link].nil?
  end

  private

  def get_game_infos(query = @barcode)
    url = "https://www.joueclub.fr/contenu/resultat-de-recherche-produits.html?searchText=#{query}"
    html = URI.open(url)
    doc = Nokogiri::HTML.parse(html)
    if no_results(doc)
      return nil
    end
    callback_url = doc.search(".product-list .product .product__content .product-visual").first.children.first.attributes["href"].value

    html = URI.open(callback_url)
    doc = Nokogiri::HTML.parse(html)


    name = get_name_of_game(doc)
    minimum_age = get_age_of_game(doc)
    image_link = get_image_link(doc)
    full_description = get_description_of_game(doc)
    description = full_description.split(".")[0..1].join(".") + "."
    min_players, max_players = get_number_of_players(full_description)
    length = get_length_of_game(full_description)

    { name: name, image_link: image_link, ean: @barcode, min_players: min_players, max_players: max_players, minimum_age: minimum_age, length: length, description: description }
  end

  def no_results(doc)
    page_text = doc.text.strip.gsub(/\s+/, " ")
    searched_text = "Oups !!! Votre sélection ne ramène aucun produit."
    page_text.include?(searched_text)
  end

  def get_description_of_game(doc)
    element = doc.search(".seo_description")
    element.children&.text&.strip if element
  end

  def get_number_of_players(description)
    players_string = description.match(/De (\d+) à/)
    if players_string
      min_players = players_string[1].to_i
      max_players = players_string[2].to_i
    elsif description.match(/Nombre de joueurs (\d+) à (\d+)/)
      min_players = description.match(/Nombre de joueurs (\d+) à (\d+)/)[1].to_i
      max_players = description.match(/Nombre de joueurs (\d+) à (\d+)/)[2].to_i
    else
      min_players = 1
      max_players = 1
    end
    return min_players, max_players
  end

  def get_length_of_game(description)
    description.match(/Durée de la partie (\d+) m/)[1].to_i
  rescue
    ""
  end

  def get_image_link(doc)
    element = doc.search(".skeepers_product__reviews")
    element.first["data-image-url"] if element
  end

  def get_name_of_game(doc)
    element = doc.search(".c-product-details-informations__container .row .c-product-details-informations__col .product__title")
    element.text&.strip.match(/Caractéristiques (.*)/).captures.first if element
  end

  def get_age_of_game(doc)
    element = doc.search(".c-product-details-informations__container .row .c-product-details-informations__col .list li")
    minimum_age = element.first.children.text.scan(/\d+/).first.to_i if element
  end
end
