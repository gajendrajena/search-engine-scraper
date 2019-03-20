require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe '#index' do

    context 'when user is not logged in ' do
      it 'it should redirect to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in ' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it 'it should render with status 200' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

end
