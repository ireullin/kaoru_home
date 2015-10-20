class AddMovieSchedulesColumns2 < ActiveRecord::Migration
    def change
        add_column :movie_schedules, :directors, :text
        add_column :movie_schedules, :dramatists, :text
        add_column :movie_schedules, :actors, :text
    end
end
