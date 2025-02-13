class BarcodeConverter
  def initialize(barcode)
    @barcode = barcode
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

    { name: name, image_link: image_link, ean: @barcode }
  end
end
