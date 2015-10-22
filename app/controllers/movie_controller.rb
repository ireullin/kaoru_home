class MovieController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [ :reserve_new, :reserve_delete]
	before_action :connect_solr, only: [:index, :schedule, :theater]

	private
	def search_keywords
		# get keywords from MovieReserve
		keywords = MovieReserve.select('keyword').where('status <> 0').pluck(:keyword).join(' OR ')
		#Rails.logger.debug('keywords="'+keywords+'"')
		return if keywords==''


		# search from solr by keywords
		rows = @solr.get(
			'select',
			params:{
				q: """
					SUMMARY:(#{keywords})
					OR NAME:(#{keywords})
					OR DIRECTORS:(#{keywords})
					OR DRAMATISTS:(#{keywords})
					OR ACTORS:(#{keywords})
					""".gsub(/[\r\n\t]/,'') ,
				fl:'MOVIE_ID,NAME',
				start:0,
				rows:1000
			}
		)["response"]["docs"]#.map{|r|r['MOVIE_ID']}
		Rails.logger.debug(rows.inspect)


		# insert into MovieHistories
		rows.each do |r|
			# status may be 0 or 1
			next if MovieHistories.select(:movie_id).where(movie_id: r['MOVIE_ID']).size > 0

			mh = MovieHistories.new
			mh.movie_id = r['MOVIE_ID']
			mh.name = r['NAME']
			mh.enable = 1
			mh.save

			@new_movies << r['NAME']
		end

	end

	public
	def index

		@new_movies = []

		search_keywords

		#@schedules = MovieSchedules.select(:movie_id, :name)
		@schedules = @solr.get(
			'select',
			params:{
				q:'*:*',
				fl:'NAME,MOVIE_ID',
				start:0,
				rows:1000
			}
		)["response"]["docs"]


		@movies = MovieHistories.where(enable: 1)
	end


	def schedule
		#@schedule = MovieSchedules.where(movie_id: params[:id]).first
		@schedule = @solr.get(
			'select',
			params:{
				q:"MOVIE_ID:#{params[:id]}",
				start:0,
				rows:1000
			}
		)["response"]["docs"][0]

		respond_to {|format| format.html { render :schedule, layout: false } }
	end


	def reserve
		@data = MovieReserve.where('status <> 0')
		respond_to {|format| format.html { render :reserve, layout: false } }
	end


	def reserve_new
		rc = MovieReserve.new
		rc.tag_id = params[:tag_id]
		rc.keyword = params[:keyword]
		rc.status = 1
		rc.save

		respond_to {|format| format.json { render json: {table_id: rc.id, tag_id: rc.tag_id, method:  'reserve_new'} } }
	end


	def reserve_delete
		rc = MovieReserve.where(tag_id: params[:tag_id]).update_all(status: 0)
		respond_to {|format| format.json { render json: {tag_id: params[:tag_id], method: 'reserve_delete'} } }
	end


	def theater

		@theaters = MovieTheater.where(enable: 1)

		params[:id] = @theaters.first.id if params[:id].nil?

		theater = MovieTheater.find(params[:id])

		#movie_schedules = MovieSchedules.where("schedules like ?", "%#{ theater.theater_name }%" )
		movie_schedules = @solr.get(
			'select',
			params:{
				q:"SCHEDULES:#{theater.theater_name}",
				start:0,
				rows:1000
			}
		)["response"]["docs"]

		#Rails.logger.debug(movie_schedules.to_s)

		@result = {theater_name: theater.theater_name, movies: [] }
		movie_schedules.each do |s|

			rc = extract_theater(theater.theater_name, s['SCHEDULES'])
			next if rc.nil?

			@result[:movies] << {
				id: s['MOVIE_ID'],
				name: s['NAME'],
				times: rc
			}

		end
	end


	def create
		@movie = MovieHistories.find_or_create_by(movie_id: params[:id])
		@movie.movie_id = params[:id]
		@movie.name = params[:name]
		@movie.enable = 1
		@movie.save

		respond_to {|format| format.any { render json: {msg: 'success', status: 0 } } }
	end


	def delete
		@movie = MovieHistories.find_or_create_by(movie_id: params[:id])
		@movie.movie_id = params[:id]
		@movie.name = params[:name]
		@movie.enable = 0
		@movie.save

		respond_to {|format| format.any { render json: {msg: 'success', status: 0 } } }
	end


	private
	def extract_theater(theater_name, schedule)

		return nil unless schedule.include?( theater_name )

		sch_obj = JSON.parse(schedule)
		sch_obj.each do |s|
			return s['times'] if s['theater'] == theater_name
		end

		return nil
	end


	def connect_solr
		@solr = RSolr.connect(url: 'http://192.168.1.222:8983/solr/movie_schedules')
	end

end
