class MoneyNoteController < ApplicationController
	layout "blank"

	def index
		@items = MoneyNoteItems.first
 	end


 	def create
 		history = MoneyNoteHistory.new
 		history.category = params[:category]
 		history.item = params[:item]
 		history.comment = params[:comment]
 		history.price = params[:price]
 		history.expended_at = params[:expended_at]
 		history.save

 		buff = params[:expended_at].split('-')
 		respond_to {|format| format.any { render json: {year: buff[0], month: buff[1] } } }
 	end


 	def history
 		condition = params[:year].rjust(4,'0') + '-' + params[:month].rjust(2,'0') + '%'
 		@data = MoneyNoteHistory.where('expended_at like ?', condition).order(expended_at: :desc , category: :asc, updated_at: :desc)
 		respond_to do |format|
        	format.html { render :history, layout: false }
      	end
 	end


 	def items
 		MoneyNoteItems.delete_all
 		rc = MoneyNoteItems.new
 		rc.items = params[:data]
 		rc.updated_at = DateTime.now
 		rc.save
 		respond_to {|format| format.any { render json: params[:data].to_json } }
 	end
end
