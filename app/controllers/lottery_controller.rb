class LotteryController < ApplicationController
  def index

  	if params[:type]=='superlottos'
  		@data = Superlottos.order(term: :desc).page(params[:page]).per(10)
  	else
  		@data = Lottery649s.order(term: :desc).page(params[:page]).per(10)
  	end
  	
  end
end
