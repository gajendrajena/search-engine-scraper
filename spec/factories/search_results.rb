FactoryBot.define do
  factory :search_result do
    keyword { "Nimble" }
    number_of_adwords { 1 }
    number_of_links { 1 }
    html_content { "HTML content" }
    total_search_result { 100 }
    association :user, factory: :user
  end
end
