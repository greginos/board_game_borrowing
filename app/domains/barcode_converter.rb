class BarcodeConverter
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
    url = "https://www.philibertnet.com/fr/recherche?search_query=#{query}"
    html = URI.open(url)
    doc = Nokogiri::HTML.parse(html)
    page_text = doc.text.strip.gsub(/\s+/, " ")
    if page_text.include?("0 résultats ont été trouvés.")
      return nil
    end

    name = get_name_of_game(doc)
    minimum_age = get_age_of_game(doc)
    min_players, max_players = get_number_of_players(doc)
    length = get_length_of_game(doc)
    image_link = get_image_link(doc)

    { name: name, image_link: image_link, ean: @barcode, min_players: min_players, max_players: max_players, minimum_age: minimum_age, length: length }
  end

  def get_number_of_players(doc)
    element = doc.search(".wrapper_product .wrapper_product_2 .nb_joueurs").first
    if element
      if element.text.strip.match?(/(.*) à (.*) joueur\(s\)/)
        min_players = element.text.strip.match(/(.*) à (.*) joueur\(s\)/).captures.first.to_i
        max_players = element.text.strip.match(/(.*) à (.*) joueur\(s\)/).captures.last.to_i
      elsif
        players = element.text.strip.match(/(.*) joueur\(s\)/).captures.first.to_i
        min_players = players
        max_players = players
      end
    end
    return min_players, max_players
  end

  def get_length_of_game(doc)
    element = doc.search(".wrapper_product .wrapper_product_2 .duree_partie").first
    if element
      length = element.text.strip
    end
    length
  end

  def get_image_link(doc)
    element = doc.search(".wrapper_product .wrapper_product_1 img").first
    image_link = element["src"] if element
  end

  def get_name_of_game(doc)
    element = doc.search(".wrapper_product .wrapper_product_2 .s_title_block").first
    name = element.text&.strip if element
  end

  def get_age_of_game(doc)
    element = doc.search(".wrapper_product .wrapper_product_2 .age").first
    if element
      minimum_age = element.text.strip.match(/à partir de (.*) ans/).captures.first.to_i
    end
  end
end
