class LotteryController < ApplicationController
  	
    skip_before_action :verify_authenticity_token

    def index
		if params[:type]=='superlottos'
			@data = Superlottos.order(term: :desc).page(params[:page]).per(10)
		elsif params[:type]=='lottery649s'
			@data = Lottery649s.order(term: :desc).page(params[:page]).per(10)
		else
			render :file => "#{Rails.root}/public/404.html",  :status => 404
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


  		respond_to do |format|
    	  format.json { render :json => @data.to_json  }
        end
	end


	def new

        unless request.remote_ip == '127.0.0.1'
            respond_to {|format| format.json { render json: {msg: 'illegal ip', status: 1 } } }
            return
        end


    	obj = JSON.parse(params[:data])

        #can't use symbol in obj
   		if obj['type']=='superlottos'
      		@data = Superlottos.new
      	elsif obj['type']=='lottery649s'
        	@data = Lottery649s.new
       	else
      		respond_to {|format| format.json { render :json => {msg: "unknown type", status: 102 } } }
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
                format.json { render json: {msg: "has been inserted", status: 0 } }
            else
                format.json { render json: {msg: "inserted failed", status: 101 } }
                #format.json { render json: @data.errors, status: :unprocessable_entity }
            end
        end
	end


    

end
