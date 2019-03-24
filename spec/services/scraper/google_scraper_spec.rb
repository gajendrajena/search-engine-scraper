require 'rails_helper'

RSpec.describe Scraper, type: :service do
  describe 'scrap' do
    it 'scraps google with default keyword when option is empty' do
      #search happy path scenarios
      #TODO: mock scrap for google
      data = Scraper::GoogleScraper.new.scrap

      expect(data).not_to be_empty

      expect(data).to have_key(:adwords)
      expect(data).to have_key(:total_result)
      expect(data).to have_key(:html)
      expect(data).to have_key(:links)
    end

    it 'scraps google when option is passed' do
      data = Scraper::GoogleScraper.new.scrap({ keyword: 'rummycircle' })

      expect(data).not_to be_empty

      expect(data).to have_key(:adwords)
      expect(data).to have_key(:total_result)
      expect(data).to have_key(:html)
      expect(data).to have_key(:links)
    end

    #TODO: search failure scenarios
    #
  end

  describe '#parse_page' do
  end

  describe '#parse_page' do
    before do
    end

    it 'set attributes and return scrapped data' do
    end

  end
end
