class CreateMovieReserves < ActiveRecord::Migration
  def change
    create_table :movie_reserves do |t|
    	t.string :tag_id
    	t.string :keyword
    	t.integer :status
    	t.timestamps
    end
  end
end
