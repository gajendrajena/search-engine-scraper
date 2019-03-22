class SearchResult < ApplicationRecord
  validates :keyword, uniqueness: true

  def self.process_keywords_csv(file)
    csv = SmarterCSV.process(file.path, row_sep: :auto, col_sep: ",", file_encoding: 'UTF-8')

    csv.slice(0,1).each do |row|
      search_result = where(" LOWER(keyword) like  LOWER('#{row[:keyword]}')")

      GoogleScrapWorker.perform_async(row[:keyword]) if search_result.blank?
    end
  end
end
