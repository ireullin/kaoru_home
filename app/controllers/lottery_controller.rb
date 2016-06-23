class LotteryController < ApplicationController

    include LotteryHelper

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

    def suggestion
    end

    def association_rule
        if params[:type]=='superlottos'
            raw_data = Superlottos.all
        elsif params[:type]=='lottery649s'
            raw_data = Lottery649s.all
        else
            redirect_to( full_url '/error.html' )
        end

        rows = Array.new
        raw_data.each{|r| rows << TermRow.new(r)}

        support_counter = Hash.new(0)
        assoc = Hash.new{|this,key| this[key] = Hash.new(0) }
        rows.each do |row|
            row.columns.each do |c1|
                support_counter[c1.num]+=1
                row.columns.each do |c2|
                    if c1.num == c2.num
                        # do nothing
                    else
                        assoc[c1.num][c2.num]+=1
                    end
                end
            end
        end

        tided_assoc = Array.new
        assoc.each do |k,v|

            row = Hash.new
            row['opened'] = 0
            row['no1'] = k
            row['no1_cnt'] = support_counter[k]
            row['no1_conf'] = 1 #confidence
            row['no1_supp'] = Rational(support_counter[k],rows.size) # support

            sorted = v.sort_by{|k1,v1| -v1 }
            sorted.each_with_index do |s, i|
                row["no#{i+2}"] = s[0] # number
                row["no#{i+2}_cnt"] = s[1] # count
                row["no#{i+2}_conf"] = Rational(s[1],support_counter[k]) # confidence
                row["no#{i+2}_supp"] = Rational(row["no#{i+2}_conf"]*row["no#{i+1}_supp"]) #aggregate support
                break if i==4
            end

            tided_assoc << row
        end

        tided_assoc.sort!{|a,b| a['no4_supp'] > b['no4_supp'] ? -1 : 1 }
        tided_assoc.each do |r|
            r['opened'] = is_opened(r, rows)
            1.upto(6){|i| r["no#{i}_supp"] = r["no#{i}_supp"].to_f }
            1.upto(6){|i| r["no#{i}_conf"] = r["no#{i}_conf"].to_f }
        end

        respond_to do |format|
            format.json { render(json: tided_assoc.to_json, layout: false) }
        end
    end


    def is_opened(assoc, orig_rows)
        assoc_str = [
            assoc['no1'],
            assoc['no2'],
            assoc['no3'],
            assoc['no4']
        ].sort!{|a,b| a < b ? -1 : 1 }.join('|')

        cnt = 0
        orig_rows.each do |row|
            orig = row.columns.map{|x| x.num}.join('|')
            cnt += 1 if orig.include?(assoc_str)
        end
        return cnt
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
            @rank = SupperlottosRank.all
            @prob_no = 18
            @prob_sp = 18

        elsif params[:type]=='lottery649s'
            @rank = Lottery649sRank.all
            @prob_no = 16
            @prob_sp = 6

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
            arr << {number: t[1], month: t[0], count: v }
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
