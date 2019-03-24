require 'rails_helper'

RSpec.describe SearchResultsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      FactoryBot.create(:search_result, {user: user})
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      search_result = FactoryBot.create(:search_result, user: user)
      get :show, params: {id: search_result.to_param}
      expect(response).to be_successful
    end
  end
end
