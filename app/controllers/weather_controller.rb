class WeatherController < ApplicationController
	
	skip_before_action :verify_authenticity_token

	def update
		obj = JSON.parse(params[:data])
	
		Weather.delete_all

		obj.each do |k,v| 
			@data = Weather.new
		    @data.weather_date = k
		    @data.des = v['des']
		    @data.max = v['max']
		    @data.min = v['min']
		    @data.city = v['city']
		    @data.save
		end

	    respond_to {|format| format.json { render json: {msg: "has been inserted", status: 0 } } }

	end


end
