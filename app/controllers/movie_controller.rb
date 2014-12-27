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


	def theater

		theaters = []
		MovieTheater.select('theater_name').where(enable: 1).each{|r| theaters << r.theater_name }

		
		tmp =[]
		move_schedules = MovieSchedules.all
		theaters.each do | theater_name  |

			tmp << {theater_name: theater_name, movies: [] }

			move_schedules.each do |s|

				rc = extract_theater(theater_name, s.schedules)
				next if rc.nil?

				tmp[-1][:movies] << {
					id: s.movie_id,
					name: s.name,
					times: rc
				}

			end
		end
		
		
		respond_to {|format| format.any { render json: tmp } }
	end


	def extract_theater(theater_name, schedule)
		
		return nil unless schedule.include?( theater_name )

		sch_obj = JSON.parse(schedule)
		sch_obj.each do |s|
			return s['times'] if s['theater'] == theater_name
		end

		return nil
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
