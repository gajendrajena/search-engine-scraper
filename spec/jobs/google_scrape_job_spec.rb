require 'rails_helper'

RSpec.describe GoogleScrapeJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  context 'with valid arguments' do
    it "runs a job and creates a SearchResult when invoked" do
      keyword = 'buy shoes'
      expect {
        GoogleScrapeJob.perform_now({keyword: keyword, user_id: user.id})
      }.to change(SearchResult, :count).by(1)
    end
  end

  context 'with invalid arguments' do
    it "runs a job and raises InvalidArgumentError when invoked" do
      keyword = 'buy shoes'
      expect {
        GoogleScrapeJob.perform_now({keyword: keyword})
      }.to raise_error(Scraper::GoogleScraper::InvalidArgumentError)
    end

    it "runs a job and raises InvalidArgumentError when invoked" do
      keyword = 'buy shoes'
      expect {
        GoogleScrapeJob.perform_now({user_id: user.id})
      }.to raise_error(Scraper::GoogleScraper::InvalidArgumentError)
    end
  end
end
