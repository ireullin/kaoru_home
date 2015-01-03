namespace :lottery_statistic do
  	desc "count_superlottos"
  	task count_superlottos: :environment do
  		count 'superlottos'
  	end


	desc "count_lottery649s"
  	task count_lottery649s: :environment do
  		count 'lottery649s'
  	end


   	def count(type)

        start_time = Time.now
        
        if type=='superlottos'
            data = Superlottos.all
            max = 38
        elsif type=='lottery649s'
            data = Lottery649s.all
            max = 49
        else
            puts "unknown type"
        end


        arr_bf_rank = Array.new(max+1){|c| c=Array.new }
        arr_bf_rank_sp = Array.new(max+1){|c| c=Array.new }
        

        data.each do |row|
            tmp = [ row['no1'],row['no2'],row['no3'],row['no4'],row['no5'],row['no6'] ]
            tmp_sp =  row['special']
            
            #1.upto(max) do |i|
            1.upto(1) do |i|
                next unless tmp.include?( i )
                arr_bf_rank[i].concat(tmp)
                arr_bf_rank_sp[i] << tmp_sp 
            end
        end


        arr_af_rank = [nil]
        arr_af_rank_sp = [nil]

        #1.upto(max) do |i|
        1.upto(1) do |i|
            arr_af_rank[i] = Statistics.rank_count(arr_bf_rank[i])
            arr_af_rank_sp[i] = Statistics.rank_count(arr_bf_rank_sp[i])
        end

        p arr_af_rank
        p arr_af_rank_sp
        

        if type=='superlottos'
            model_obj = SupperlottosCount
        elsif type=='lottery649s'
            #model_obj = Lottery649s
        else
            puts "unknown type"
        end


        #1.upto(max) do |i|
        1.upto(1) do |i|
        	model_obj.find_or_create_by(id: i) do |row|
  				row.no1 = arr_af_rank[i][:numbers][0]
  				row.no2 = arr_af_rank[i][:numbers][1]
  				row.no3 = arr_af_rank[i][:numbers][2]
  				row.no4 = arr_af_rank[i][:numbers][3]
  				row.no5 = arr_af_rank[i][:numbers][4]
  				row.no6 = arr_af_rank[i][:numbers][5]
  				row.special = arr_af_rank_sp[i][:numbers][0]

  				row.no1_cnt = arr_af_rank[i][:count][0]
  				row.no2_cnt = arr_af_rank[i][:count][1]
  				row.no3_cnt = arr_af_rank[i][:count][2]
  				row.no4_cnt = arr_af_rank[i][:count][3]
  				row.no5_cnt = arr_af_rank[i][:count][4]
  				row.no6_cnt = arr_af_rank[i][:count][5]
  				row.special_cnt = arr_af_rank_sp[i][:count][0]
			end

        end


        puts 'total time:' + (Time.now - start_time).to_s + " seconds"
    end

end
