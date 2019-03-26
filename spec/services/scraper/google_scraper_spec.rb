require 'rails_helper'

RSpec.describe Scraper, type: :service do
  describe 'scrap' do
    #search happy path scenarios
    context 'when keyword is valid' do
      before do
        @file = Nokogiri::HTML(open(file_fixture('rummycircle-GoogleSearch.html')))
        allow_any_instance_of(Scraper::GoogleScraper).to receive(:web_search).and_return(@file)
      end

      it 'scraps google when option is passed' do
        data = Scraper::GoogleScraper.new.scrap({ keyword: 'rummycircle' })

        expect(data).not_to be_empty

        expect(data).to have_key(:adwords)
        expect(data).to have_key(:total_result)
        expect(data).to have_key(:html)
        expect(data).to have_key(:links)
      end
    end

    #search failure scenarios
    context 'when keyword is invalid' do
      before do
        @file = Nokogiri::HTML(open(file_fixture('invalidsearch-GoogleSearch.html')))
        allow_any_instance_of(Scraper::GoogleScraper).to receive(:web_search).and_return(@file)
      end

      it 'raises exception if keyword is empty' do
        expect{ Scraper::GoogleScraper.new.scrap }.to raise_error(Scraper::GoogleScraper::EmptyKeywordError)
      end

      it 'scraps google with default keyword if option is empty' do
        expect{Scraper::GoogleScraper.new.scrap(keyword: '')}.to raise_error(Scraper::GoogleScraper::EmptyKeywordError)
      end

      it 'scraps google when invalid keyword is passed in option' do
        expect{
          Scraper::GoogleScraper.new.scrap({ keyword: 'lskdjfljsdlkfjsldkjflksdjf' })
        }.to raise_error(Scraper::GoogleScraper::ExtractElementError)
      end
    end
  end
end
