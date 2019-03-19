class WelcomeController < ApplicationController
  def index
    redirect_to new_user_registration_path unless current_user
  end
end
