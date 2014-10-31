class LotteryStatisticController < ApplicationController

	#before_action :filter_ip

	def count

        if params[:type]=='superlottos'
      		data = Superlottos.all
      	elsif params[:type]=='lottery649s'
        	data = Lottery649s.all
       	else
      		respond_to {|format| format.json { render :json => {msg: "unknown type", status: 102 } } }
            return
      	end

        
        normal_no = Array.new
        special_no = Array.new
        data.each do |row|
            normal_no.concat([ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ])
            special_no.push(row['special'])
        end

        normal_no_rc = Statistics.rank_count(normal_no)
        special_no_rc = Statistics.rank_count(special_no)


        max = normal_no_rc[:numbers][0]
        normal_max = Array.new
        special_max = Array.new
        data.each do |row|
            
            tmp = [ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ]

            next unless tmp.include?( max.to_i )

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
            format.any { render json: total.to_json }
        end
    end



    private
    def filter_ip
    	unless request.remote_ip == '127.0.0.1'
            respond_to {|format| format.any { render json: {msg: 'illegal ip', status: 1 } } }
            return
        end
    end
end
