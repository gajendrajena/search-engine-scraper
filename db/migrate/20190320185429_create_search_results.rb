class CreateSearchResults < ActiveRecord::Migration[5.2]
  def change
    create_table :search_results do |t|
      t.string :keyword, index: true
      t.integer :user_id
      t.integer :number_of_adwords
      t.integer :number_of_links
      t.text :html_content
      t.bigint :total_search_result

      t.timestamps
    end
  end
end
