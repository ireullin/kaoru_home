class LotteryController < ApplicationController
  	
    skip_before_action :verify_authenticity_token

    def index
		if params[:type]=='superlottos'
			@data = Superlottos.order(term: :desc).page(params[:page]).per(50) # page is from kaminari
		elsif params[:type]=='lottery649s'
			@data = Lottery649s.order(term: :desc).page(params[:page]).per(50)
		else
            redirect_to( full_url '/error.html' )
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


    def statistic
        if params[:type]=='superlottos'
            @high_ral = LotteryStatistic.where(statistic_type: 'superlottos_count_high_ral').first
            @high_ral['context'] = JSON.parse(@high_ral['context'])

            @normal = LotteryStatistic.where(statistic_type: 'superlottos_count').first 
            @normal['context'] = JSON.parse(@normal['context'])
        
        elsif params[:type]=='lottery649s'
            @high_ral = LotteryStatistic.where(statistic_type: 'lottery649s_count_high_ral').first
            @high_ral['context'] = JSON.parse(@high_ral['context'])

            @normal = LotteryStatistic.where(statistic_type: 'lottery649s_count').first
            @normal['context'] = JSON.parse(@normal['context'])
        else
            redirect_to( full_url '/error.html' )
        end
    end
    

    def bubble_chart

        if params[:type]=='superlottos'
            @data = Superlottos.all
        elsif params[:type]=='lottery649s'
            @data = Lottery649s.all
        else
            redirect_to( full_url '/error.html' )
        end

        @map_buff = {}
        @data.each do |row|
            month = row.announced_at.month.to_s
            
            fill_to_buff(month, row.no1)
            fill_to_buff(month, row.no2)
            fill_to_buff(month, row.no3)
            fill_to_buff(month, row.no4)
            fill_to_buff(month, row.no5)
            fill_to_buff(month, row.no6)
        end

        respond_to do |format|
            format.json { render json: convert_to_bubblechart_data }
        end
    end


    private
    def convert_to_bubblechart_data
        arr = []
        @map_buff.each do |k,v|
            t = k.split('-')
            arr << {x: t[1], y: t[0], value: v }
        end
        return arr
    end


    def fill_to_buff(month, no)
        key = "#{month}-#{no}"

        if @map_buff.has_key?(key) 
            @map_buff[key] = @map_buff[key] + 1
        else
            @map_buff[key] =  1
        end
    end
end
