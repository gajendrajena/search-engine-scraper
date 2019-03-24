class SearchResult < ApplicationRecord
  # validations
  validates :keyword, uniqueness: true

  # Associations
  belongs_to :user

  #process csv file for keywords
  #
  def self.process_keywords_csv(file=nil, user_id)
    keywords_status = {parsed: [], buffered: [], all: []}
    begin
      csv = SmarterCSV.process(file.path, row_sep: :auto, col_sep: ",", file_encoding: 'UTF-8')
    rescue Exception => e
      Rails.logger.error('Error reading file')
    end

    csv.each do |row|
      process_keyword(row[:keyword], keywords_status, user_id) if row[:keyword].present?
    end if csv.present?

    keywords_status
  end

  #process a keyword from csv
  #
  def self.process_keyword(keyword='', keywords_status, user_id)
    return keywords_status if keyword.empty?
    keywords_status[:all] << keyword
    search_result = where(" LOWER(keyword) like  LOWER('#{keyword}')")

    if search_result.blank?
      GoogleScrapWorker.perform_async(keyword, user_id)
      keywords_status[:parsed] << keyword
    else
      keywords_status[:buffered] << keyword
    end
  end


  def self.create_from_scrap_data(scrap_data)
    html = scrap_data[:html].force_encoding("UTF-8") if scrap_data[:html]
    search_result = create({
      keyword:              scrap_data[:keyword],
      number_of_adwords:    scrap_data[:adwords].try(:length).to_i,
      number_of_links:      scrap_data[:links].try(:length).to_i,
      html_content:         html,
      total_search_result:  scrap_data[:total_result],
      user_id:              scrap_data[:user_id]
    })
    puts 'created search_result' + '*' * 100
    puts search_result.inspect
    search_result
  end
end
