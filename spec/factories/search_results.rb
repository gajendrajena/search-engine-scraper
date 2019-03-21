FactoryBot.define do
  factory :search_result do
    keyword { "MyString" }
    number_of_adwords { 1 }
    number_of_links { 1 }
    html_content { "MyText" }
    total_search_result { "" }
  end
end
