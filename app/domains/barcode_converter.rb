class BarcodeConverter
  def initialize(barcode, user_id)
    @barcode = barcode
    @user_id = user_id
  end

  def convert
    raise StandardError if @barcode.nil?
    boardgame = BoardGame.find_by(ean: @barcode)
    return boardgame unless boardgame.nil?
    url = "https://www.philibertnet.com/fr/recherche?search_query=#{@barcode}"

    html = URI.open(url)
    doc = Nokogiri::HTML.parse(html)

    element = doc.search(".wrapper_product .wrapper_product_2 .s_title_block").first
    name = element.text.strip

    element = doc.search(".wrapper_product .wrapper_product_1 img").first
    image_link = element["src"]

    boardgame = BoardGame.create!(name: name, image_link: image_link, ean: @barcode)
    if boardgame && @user_id
      Game.create!(user: User.find(@user_id), board_game: boardgame)
    end
    boardgame
  end
end
