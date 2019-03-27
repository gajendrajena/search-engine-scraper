require 'rails_helper'

RSpec.describe ScraperController, type: :controller do
  describe '#index' do
    context 'when user is not logged in ' do
      it 'redirects to login page' do
        post :scrap
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in ' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in user
        allow(SearchResult).to receive(:process_keywords_csv).and_return(true)
      end

      context 'when attachment is present' do
        it 'allows user to scrap' do
          post :scrap, params: { file: fixture_file_upload("/files/keywords.csv") }

          expect(response).to redirect_to('/')
          expect(flash[:notice]).to eq('Uploaded successfully')
        end
      end

      context 'when attachment is absent' do
        it 'renders scrape form with error' do
          post :scrap, params: {}

          expect(response.status).to eq(200)
          expect(flash[:error]).to eq('Please choose a file to upload')
        end
      end
    end
  end
end
