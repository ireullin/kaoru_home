class MovieController < ApplicationController
	
	skip_before_action :verify_authenticity_token, only: [:update_schedules]

	def index
		@movies = MovieSchedules.select(:id, :name)
	end


	def schedule
		#, layout: false
		#if not find?
		@schedule = MovieSchedules.where(id: params[:id]).first
		respond_to {|format| format.html { render :schedule } }
	end


	def update_schedules
		
		#return unless filter_ip

		obj = JSON.parse(params[:data])
		MovieSchedules.delete_all
		obj.each do | movie |
			row = MovieSchedules.new
			row.id = movie['id']
			row.name = movie['name']
			row.schedules = movie['theaters'].to_json
			row.created_at = Time.now.localtime.strftime("%Y-%m-%d %H:%M:%S")
			row.save
		end

		respond_to {|format| format.json { render json: {msg: 'success', status: 0 } } }
	end


	private
    def filter_ip
    	unless request.remote_ip == '127.0.0.1'
            respond_to {|format| format.json { render json: {msg: 'illegal ip', status: 1 } } }
            return false
        end
    end
end
