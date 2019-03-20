require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe GoogleScrapWorker, type: :worker do
  it "schedules a job when invoked" do
    keyword = 'buy shoes'

    expect {
      GoogleScrapWorker.perform_async(keyword)
    }.to change(GoogleScrapWorker.jobs, :size).by(1)
  end
end
