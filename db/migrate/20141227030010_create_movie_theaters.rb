class CreateMovieTheaters < ActiveRecord::Migration
  def change
    create_table :movie_theaters do |t|
    	t.string :theater_name
    	t.integer :enable
      	t.timestamps
    end
  end
end
