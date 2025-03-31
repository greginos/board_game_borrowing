module BarcodeManager
  class ToyStore
    SOURCE_URL = "https://www.joueclub.fr/contenu/resultat-de-recherche-produits.html?searchText="
    def initialize(barcode, query)
      @barcode = barcode
      @query = query
    end

    def get_list_of_found_games
      query = @barcode || @query
      url = "#{SOURCE_URL}#{query}"
      html = URI.open(url)
      doc = Nokogiri::HTML.parse(html)
      if no_results(doc)
        return nil
      end
      values = []
      doc.search(".product__content a").first(3).each do |element|
        values <<  { name: element.attribute("title").value, callback_url: element.attribute("href").value }
      end
      { origin: "toy_store", values: values.uniq }
    end

    def convert(url)
      get_game_infos(url)
    end

    def fill_image
      board_game = BoardGame.find_by(ean: @barcode)
      values = get_list_of_found_games
      if values.nil?
        values = get_game_infos(board_game.name)
      end
      get_game_infos(values[:callback_url])
      board_game.update(image_link: values[:image_link]) unless values[:image_link].nil?
    end

    private

    def get_game_infos(url)
      html = URI.open(url)
      doc = Nokogiri::HTML.parse(html)


      name = get_name_of_game(doc)
      minimum_age = get_age_of_game(doc)
      image_link = get_image_link(doc)
      full_description = get_description_of_game(doc)
      description = full_description.split(".")[0..1].join(".") + "."
      min_players, max_players = get_number_of_players(full_description)
      length = get_length_of_game(full_description)

      {
        name: name,
        image_link: image_link,
        ean: @barcode || "",
        min_players: min_players,
        max_players: max_players,
        minimum_age: minimum_age,
        length: length,
        description: description
      }
    end

    def no_results(doc)
      page_text = doc.text.strip.gsub(/\s+/, " ")
      searched_text = "Oups !!! Votre sélection ne ramène aucun produit."
      page_text.include?(searched_text)
    end

    def get_description_of_game(doc)
      begin
        element = doc.search(".seo_description")
        element.children&.text&.strip if element
      rescue
        ""
      end
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
      begin
        doc.at('meta[name="og:image"]')["content"].sub(%r{^https://[^/]+(https://)}, '\1')
      rescue
        ""
      end
    end

    def get_name_of_game(doc)
      begin
        element = doc.search(".c-product-details-informations__container .row .c-product-details-informations__col .product__title")
        element.text&.strip.match(/Caractéristiques (.*)/).captures.first if element
      rescue
        ""
      end
    end

    def get_age_of_game(doc)
      begin
        element = doc.search(".c-product-details-informations__container .row .c-product-details-informations__col .list li")
        minimum_age = element.first.children.text.scan(/\d+/).first.to_i if element
      rescue
        ""
      end
    end
  end
end
