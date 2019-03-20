require 'rails_helper'

RSpec.describe Scraper, type: :service do

  describe '.initialize' do

    it 'should return valid scraper when option is passed' do
      scraper = Scraper::SearchEngineScraper.new('google').scraper
      expect(scraper).to be_instance_of(Scraper::GoogleScraper)
    end

    it 'should return nil scraper when option is nil' do
      expect(Scraper::SearchEngineScraper.new(nil).scraper).to be_nil
    end

  end

  describe '#scrap' do
    before do
      expect_any_instance_of(Scraper::GoogleScraper).to receive(:scrap).and_return(true)
    end

    it 'should return valid scraper when option is passed' do
      scraper = Scraper::SearchEngineScraper.new('google').scraper
      expect(scraper.scrap).to eq(true)
    end

  end
end
