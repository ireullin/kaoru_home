class AddMovieSchedulesColumns < ActiveRecord::Migration
    def change
        add_column :movie_schedules, :summary, :string
        add_column :movie_schedules, :runtime, :string
    end
end
