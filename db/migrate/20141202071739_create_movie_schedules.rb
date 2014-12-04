class CreateMovieSchedules < ActiveRecord::Migration
  def change
    create_table :movie_schedules, :id => false do |t|
      t.string :id
      t.string :name
      t.text :schedules
      t.datetime :created_at

      end

      add_index :movie_schedules, :id, :unique => true
  end
end
