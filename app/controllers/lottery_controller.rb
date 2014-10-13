class LotteryController < ApplicationController
  	def index
  		if params[:type]=='superlottos'
  			@data = Superlottos.order(term: :desc).page(params[:page]).per(10)
  		elsif params[:type]=='lottery649s'
  			@data = Lottery649s.order(term: :desc).page(params[:page]).per(10)
  		else
  			#page not found
  		end
  	end

	def newest
		if params[:type]=='superlottos'
  			@data = Superlottos.last
  		elsif params[:type]=='lottery649s'
  			@data = Lottery649s.last
  		else
  			@data = 'no data'
  		end

  		# it's neccessary for phantomjs
    	headers['Access-Control-Allow-Origin'] = '*'
    	headers['Access-Control-Allow-Headers'] = 'GET, POST, PUT, DELETE, OPTIONS'
    	headers['Access-Control-Allow-Methods'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
  		
  		respond_to do |format|
    	    format.json { render :json => @data.to_json  }
      	end
	end

	def new

		if params[:type]=='superlottos'
  			#data = JSON.parse( params[:data] )
  			Superlottos.new(  params[:data] )
  			Superlottos.save

  		elsif params[:type]=='lottery649s'
			Lottery649s.new(  params[:data] )
  			Lottery649s.save

  		else
  			
  		end

  		# it's neccessary for phantomjs
  		headers['Access-Control-Allow-Origin'] = '*'
    	headers['Access-Control-Allow-Headers'] = 'GET, POST, PUT, DELETE, OPTIONS'
    	headers['Access-Control-Allow-Methods'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')

		respond_to do |format|
    	    format.json { render :json => '@data.to_json'  }
      	end
	end

end
