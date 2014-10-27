class DrinkController < ApplicationController
  

  	skip_before_action :verify_authenticity_token

	def index

		@data = Drinks.first

	end

  	def update
		Drinks.delete_all
		@data = Drinks.new( context: params[:data] )
	    @data.save

	    respond_to {|format| format.json { render json: {msg: params[:data], status: 0 } } }

	end

end
