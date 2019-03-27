require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  let(:user) { FactoryBot.create(:user)}
  before { allow(GoogleScrapeJob).to receive(:perform_later).and_return(true) }

  describe '.process_keywords_csv' do

    it 'parses the csv file for keywords and returns keywords_status if csv file is passed' do
      keywords_status = SearchResult.process_keywords_csv(fixture_file_upload("/files/keywords.csv"), user.id)

      expect(keywords_status[:all]).to eq(keywords_status[:parsed] + keywords_status[:buffered])
    end

    it 'parses the csv file for keywords and returns empty if csv file is not passed' do
      keywords_status = SearchResult.process_keywords_csv(nil, user.id)

      expect(keywords_status[:all]).to be_empty
      expect(keywords_status[:parsed]).to be_empty
      expect(keywords_status[:buffered]).to be_empty
    end
  end

  describe '.process_keyword' do
    let(:keywords_status) { { parsed: [], buffered: [], all: [] } }

    it 'returns keywords_status' do
      SearchResult.process_keyword('RommyCircle', keywords_status, user.id)

      expect(keywords_status[:all]).to eq(keywords_status[:parsed] + keywords_status[:buffered])
    end

    it 'returns empty keywords_status if empty keyword is passed' do
      SearchResult.process_keyword('', keywords_status, user.id)

      expect(keywords_status[:all]).to be_empty
      expect(keywords_status[:parsed]).to be_empty
      expect(keywords_status[:buffered]).to be_empty
    end
  end

  describe '.create_from_scrap_data' do
    let(:keywords_status) { { parsed: [], buffered: [], all: [] } }
    let(:user) { FactoryBot.create(:user) }
    let(:scrap_data) { {keyword: 'rummycircle', adwords: [], links: [], html: 'Sample html', total_result: 100, user_id: user.id} }

    context 'when user is signed in' do
      it 'returns keywords_status' do
        search_result = SearchResult.create_from_scrap_data(scrap_data)

        expect(search_result).to be_present
        expect(search_result).to be_an_instance_of(SearchResult)
        expect(search_result.errors).to be_empty
      end
    end

    context 'when user is not signed in' do
      it 'fails to create search_result' do
        scrap_data[:user_id] = nil
        search_result = SearchResult.create_from_scrap_data(scrap_data)

        expect(search_result.errors).to be_present
      end
    end
  end
end
