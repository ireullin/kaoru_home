class MovieController < ApplicationController
	
	skip_before_action :verify_authenticity_token, only: [:update_schedules]

	def index
		@schedules = MovieSchedules.select(:movie_id, :name)
		@movies = MovieHistories.where(enable: 1)
	end


	def schedule
		@schedule = MovieSchedules.where(movie_id: params[:id]).first
		respond_to {|format| format.html { render :schedule, layout: false } }
	end


	def create
		@movie = MovieHistories.find_or_create_by(movie_id: params[:id])
		@movie.movie_id = params[:id]
		@movie.name = params[:name]
		@movie.enable = 1
		@movie.save

		respond_to {|format| format.any { render json: {msg: 'success', status: 0 } } }
	end


	def delete
		@movie = MovieHistories.find_or_create_by(movie_id: params[:id])
		@movie.movie_id = params[:id]
		@movie.name = params[:name]
		@movie.enable = 0
		@movie.save

		respond_to {|format| format.any { render json: {msg: 'success', status: 0 } } }
	end


	def update_schedules
		
		unless request.remote_ip == '127.0.0.1'
            respond_to {|format| format.json { render json: {msg: 'illegal ip', status: 1 } } }
            return false
        end

		obj = JSON.parse(params[:data])
		MovieSchedules.delete_all
		obj.each do | movie |
			row = MovieSchedules.new
			row.movie_id = movie['movie_id']
			row.name = movie['name']
			row.schedules = movie['theaters'].to_json
			row.created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
			row.save
		end

		respond_to {|format| format.json { render json: {msg: 'success', status: 0 } } }
	end

end
