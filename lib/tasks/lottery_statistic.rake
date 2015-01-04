namespace :lottery_statistic do
  	desc "superlottos_rank"
  	task superlottos_rank: :environment do
  		rank 'superlottos'
  	end


	desc "lottery649s_rank"
  	task lottery649s_rank: :environment do
  		rank 'lottery649s'
  	end


   	def rank(type)

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
            
            1.upto(max) do |i|
            #1.upto(1) do |i|
                next unless tmp.include?( i )
                arr_bf_rank[i].concat(tmp)
                arr_bf_rank_sp[i] << tmp_sp 
            end
        end


        arr_af_rank = [nil]
        arr_af_rank_sp = [nil]

        1.upto(max) do |i|
        #1.upto(1) do |i|
            arr_af_rank[i] = Statistics.rank_count(arr_bf_rank[i])
            arr_af_rank_sp[i] = Statistics.rank_count(arr_bf_rank_sp[i])
        end

        #p arr_af_rank
        #p arr_af_rank_sp
        

        if type=='superlottos'
            model_obj = SupperlottosRank
        elsif type=='lottery649s'
            model_obj = Lottery649sRank
        else
            puts "unknown type"
        end


        1.upto(max) do |i|
        #1.upto(1) do |i|

        	content = { normal: arr_af_rank[i], special: arr_af_rank_sp[i]}
        	p content.to_json

        	model_obj.find_or_create_by(id: i) do |row|
  				row.content = content.to_json
			end

        end


        puts 'total time:' + (Time.now - start_time).to_s + " seconds"
    end

end
