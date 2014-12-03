class CreateMovieHistories < ActiveRecord::Migration
  def change
    create_table :movie_histories do |t|
      t.string :movie_id
      t.string :name
      t.integer :enable

      t.timestamps
    end

    add_index :movie_histories, :movie_id, :unique => true
  end
end
