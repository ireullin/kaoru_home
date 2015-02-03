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
 		@id = history.id

 		buff = params[:expended_at].split('-')
 		params[:year] = buff[0]
 		params[:month] = buff[1]

 		render_table
 	end


 	def rate
 		condition = params[:year].rjust(4,'0') + '-' + params[:month].rjust(2,'0') + '%'
 		@data = MoneyNoteHistory
 			.select('category, sum(price) as sum_price')
 			.where('expended_at like ?', condition)
 			.group('category')

 		respond_to do |format|
        	format.json { render json: @data }
      	end
 	end


 	def history
 		render_table
 	end


 	def items
 		MoneyNoteItems.delete_all
 		rc = MoneyNoteItems.new
 		rc.items = params[:data]
 		rc.updated_at = DateTime.now
 		rc.save
 		respond_to {|format| format.any { render json: params[:data].to_json } }
 	end


    def edit
        @row = MoneyNoteHistory.find(params[:id])
    end


    def update
        @row = MoneyNoteHistory.find(params[:id])
        @row.category = params[:category]
        @row.item = params[:item]
        @row.price = params[:price]
        @row.comment = params[:comment]
        @row.expended_at = params[:expended_at]
        @row.save

        respond_to do |format|
            format.html { redirect_to(full_url('money_note')) }
        end
    end


 	private
 	def render_table
 		condition = params[:year].rjust(4,'0') + '-' + params[:month].rjust(2,'0') + '%'
 		@data = MoneyNoteHistory.where('expended_at like ?', condition).order(expended_at: :desc , category: :asc, updated_at: :desc)
 		respond_to do |format|
        	format.html { render :history, layout: false }
      	end
 	end
end
