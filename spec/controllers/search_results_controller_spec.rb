require 'rails_helper'

RSpec.describe SearchResultsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # SearchResult. As you add validations to SearchResult, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SearchResultsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      SearchResult.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      search_result = SearchResult.create! valid_attributes
      get :show, params: {id: search_result.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end
end
