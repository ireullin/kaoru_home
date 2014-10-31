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


    def refresh

        data = Superlottos.all
        
        normal_no = Array.new
        special_no = Array.new
        data.each do |row|
            normal_no.concat([ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ])
            special_no.push(row['special'])
        end

        normal_no_rc = Statistics.rank_count(normal_no)
        special_no_rc = Statistics.rank_count(special_no)


        max = normal_no_rc['numbers'][0]
        normal_max = Array.new
        special_max = Array.new
        data.each do |row|
            next unless[ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ].include?(max)

            normal_max.concat([ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ])
            special_max.push(row['special'])
        end

        normal_max_rc = Statistics.rank_count(normal_max)
        special_max_rc = Statistics.rank_count(special_max)

        total = {
            normal_no_rc: normal_no_rc,
            special_no_rc: special_no_rc,
            normal_max_rc: normal_max_rc,
            special_max_rc: special_max_rc
        }


        respond_to do |format|
            format.json { render json: total.to_json }
        end
    end

end
