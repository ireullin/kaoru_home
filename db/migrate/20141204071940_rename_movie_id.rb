class RenameMovieId < ActiveRecord::Migration
  	def change
  		rename_column :movie_schedules, :id, :movie_id
  	end
end
