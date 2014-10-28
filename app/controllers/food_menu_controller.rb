class FoodMenuController < ApplicationController

	def index
		@data = FoodMenu.where( :food_type => params[:type] ).first
	end

  	def update

	    FoodMenu.where( :food_type => params[:type] ).delete_all
	    @data = FoodMenu.new( food_type: params[:type], context: params[:data] )
	    @data.save
	    
	    respond_to {|format| format.json { render json: {msg: params[:type], status: 0 } } }
	end
end
