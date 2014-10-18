class LotteryController < ApplicationController
  	
    skip_before_action :verify_authenticity_token

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
    	#headers['Access-Control-Allow-Origin'] = '*'
    	#headers['Access-Control-Allow-Headers'] = 'GET, POST, PUT, DELETE, OPTIONS'
    	#headers['Access-Control-Allow-Methods'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
  		
  		respond_to do |format|
    	  format.json { render :json => @data.to_json  }
      end
	end


	def new

		obj = JSON.parse(params[:data])


    #can't use symbol in obj
		if obj['type']=='superlottos'
  		@data = Superlottos.new
  	elsif obj['type']=='lottery649s'
    	@data = Lottery649s.new
   	else
  		respond_to {|format| format.json { render :json => obj['type'] }}
      return
  	end

    @data.term = obj['term']
    @data.no1 = obj['no1']
    @data.no2 = obj['no2']
    @data.no3 = obj['no3']
    @data.no4 = obj['no4']
    @data.no5 = obj['no5']
    @data.no6 = obj['no6']
    @data.special = obj['special']
    @data.announced_at = obj['announced_at']


    respond_to do |format|
      if @data.save
        format.json { render :show, status: :ok, location: @data }
      else
        format.json { render json: @data.errors, status: :unprocessable_entity }
      end
    end

		
	end

end
