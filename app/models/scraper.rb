require "net/http"

class Scraper
  attr_reader :document

    # intialize the class by taing an url and returning the document
  def initialize(url)
    response = Net::HTTP.get(URI(url))
    @document = Nokogiri::HTML(response)
  end

  # get the text based on css selector
  def text(selector:)
    document.at_css(selector).text
  end

  # check if a selector is present
  def present?(selector:)
    document.at_css(selector).present?
  end
end
