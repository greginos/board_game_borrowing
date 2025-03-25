class BarcodeConverter
  def initialize(barcode)
    @barcode = barcode
  end

  def convert
    raise StandardError if @barcode.nil?
    boardgame = BoardGame.find_by(ean: @barcode)
    return boardgame if boardgame

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
    if no_results(doc)
      return nil
    end

    callback_url = doc.search(".wrapper_product .s_title_block").first.elements.first["href"].split("?").first
    html = URI.open(callback_url)
    doc = Nokogiri::HTML.parse(html)

    name = get_name_of_game(doc)
    minimum_age = get_age_of_game(doc)
    min_players, max_players = get_number_of_players(doc)
    length = get_length_of_game(doc)
    image_link = get_image_link(doc)
    description = get_description_of_game(doc)
    {
      name: name,
      image_link: image_link,
      ean: @barcode,
      min_players: min_players,
      max_players: max_players,
      minimum_age: minimum_age,
      length: length,
      description: description
    }
  end

  def no_results(doc)
    page_text = doc.text.strip.gsub(/\s+/, " ")
    searched_text = "0 résultats ont été trouvés."
    page_text.include?(searched_text)
  end

  def get_number_of_players(doc)
    element = doc.search(".nb_joueurs").first
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
    doc.search(".duree_partie").first.text.strip
  rescue
    ""
  end

  def get_image_link(doc)
    doc.search("#bigpic").first["src"]
  end

  def get_name_of_game(doc)
    doc.search("#product_name").text
  end

  def get_age_of_game(doc)
    doc.search(".age").first.text.strip.match(/à partir de (.*) ans/).captures.first.to_i
  end

  def get_description_of_game(doc)
    doc.search("#short_description_content").text
  end
end
