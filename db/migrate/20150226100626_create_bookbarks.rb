class CreateBookbarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
    	t.string  :bookmark_name
    	t.text :bookmark_url
    	t.integer :enable
      	t.timestamps
    end
  end
end
