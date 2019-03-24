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

      it 'allows user to scrap' do
        expect(response.status).to eq(200)
        post :scrap, params: { file: fixture_file_upload("/files/keywords.csv") }

        expect(response).to redirect_to('/')
        expect(flash[:notice]).to eq('Uploaded successfully')
      end
    end
  end
end
