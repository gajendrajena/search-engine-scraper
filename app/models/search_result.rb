class SearchResult < ApplicationRecord
  validates :keyword, uniqueness: true

  def self.process_keywords_csv(file)
    csv = SmarterCSV.process(file.path, row_sep: :auto, col_sep: ",", file_encoding: 'UTF-8')

    binding.pry

    csv.each do |row|
      search_result = where(keyword: row['keyword'])
      GoogleScrapWorker.perform_async(keyword: keyword) if search_result.blank?
    end
  end
end
