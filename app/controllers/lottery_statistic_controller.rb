
# this controller is only for statistic calculate
class LotteryStatisticController < ApplicationController

	#before_action :filter_ip



    def rank

        @start_time = Time.now

        if params[:type]=='superlottos'
            data = Superlottos.all
            @max = 38
        elsif params[:type]=='lottery649s'
            data = Lottery649s.all
            @max = 49
        else
            respond_to do |format|
                format.json { render :json => {msg: "unknown type", status: 102 } } 
                format.html { redirect_to( full_url '/error.html' ) }
            end
            return
        end

        @arr_bf_rank = Array.new(@max+1){|c| c=Array.new }
        @arr_bf_rank_sp = Array.new

        data.each do |row|
            tmp = [ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ]
            tmp_sp =  row['special']
            #1.upto(@max) do |i|
            1.upto(1) do |i|
                next unless tmp.include?( i )
                @arr_bf_rank[i].concat(tmp)
                @arr_bf_rank_sp[i].concat( tmp_sp )
            end
        end

        @arr_af_rank = [nil]
        #1.upto(@max) do |i|
        1.upto(1) do |i|
            @arr_af_rank[i] = Statistics.rank_count(@arr_bf_rank[i])
            @arr_af_rank_sp[i] = Statistics.rank_count(@arr_bf_rank_sp[i])
        end



        respond_to do |format|
            format.json { render json: @arr_af_rank_sp  } 
            format.html { render :rank, layout: 'blank' }
        end

    end


	def count

        if params[:type]=='superlottos'
      		data = Superlottos.all
      	elsif params[:type]=='lottery649s'
        	data = Lottery649s.all
       	else
      		respond_to {|format| format.any { render :json => {msg: "unknown type", status: 102 } } }
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


        if params[:type]=='superlottos'
        	LotteryStatistic.where( statistic_type: 'superlottos_count' ).delete_all
      		LotteryStatistic.new( statistic_type: 'superlottos_count', context:{normal: normal_no_rc, special: special_no_rc }.to_json  ).save
      	else
      		LotteryStatistic.where( statistic_type: 'lottery649s_count' ).delete_all
      		LotteryStatistic.new( statistic_type: 'lottery649s_count', context:{normal: normal_no_rc, special: special_no_rc }.to_json  ).save
      	end


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


        if params[:type]=='superlottos'
        	LotteryStatistic.where( statistic_type: 'superlottos_count_high_ral' ).delete_all
      		LotteryStatistic.new( statistic_type: 'superlottos_count_high_ral', context:{normal: normal_max_rc, special: special_max_rc }.to_json  ).save
      	else
      		LotteryStatistic.where( statistic_type: 'lottery649s_count_high_ral' ).delete_all
      		LotteryStatistic.new( statistic_type: 'lottery649s_count_high_ral', context:{normal: normal_max_rc, special: special_max_rc }.to_json  ).save
      	end


      	respond_to {|format| format.any { render :json => {msg: "OK", status: 0 } } }
    end



    private
    def filter_ip
    	unless request.remote_ip == '127.0.0.1'
            respond_to {|format| format.any { render json: {msg: 'illegal ip', status: 1 } } }
            return
        end
    end
end
