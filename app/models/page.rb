class Page < ApplicationRecord
  belongs_to :last_result, class_name: "Result"
  has_many :results

  validates :name, :url, :check_type, :selector, presence: true
  validates :match_text, presence: {if: -> {check_type == "text"}}

  # this fundtion runs the check and then sends an email notifying of the results
  def run_and_notify
    run_check
    last_result.notify
  end

  # this function runs the check based ont he params given
  def run_check
    # scrape the url
    scraper = Scraper.new(url)

    # switch case for different chcek_types
    result = case check_type
      when "text"
        scraper.text(selector: selector).downcase == match_text.downcase
      when "present"
        scraper.present?(selector: selector)
      when "missing"
        !scraper.present?(selector: selector)
      end
    
    # create a new result record
    result = results.create(success: result)
    update(last_result: result)
  end
end
