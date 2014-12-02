require 'net/http'
require 'nokogiri'
require 'json'


$URL = 'www.atmovies.com.tw'
$movies = Hash.new
$schedule = Array.new

def parse_theater(div)
	
	#p div.css("a")[0].content.gsub(/[\r\n\t ]/,'')
	data = {
		theater: div.css("a")[0].content.gsub(/[\r\n\t ]/,''),
		times: []
	}
	

	div.css(".col-2").each do |row|
		times = row.content.gsub(/[\r\n\t]/,'').split(' ')
		data[:times].concat( times )
	end

	return data
end


def get_content(id, name)
	Net::HTTP.start($URL,80) do |http|
		
		movie = { id: id, name: name, theaters: [] }

		rsp = http.get("/showtime/showtime.asp?film_id=#{id}&area=a02")
		a = rsp.body.encode("UTF-8","CP950", :invalid => :replace, :undef => :replace, :replace => "")
		#p a
		html_doc = Nokogiri::HTML(a)
		html_doc.css('.showtime01').each do |div|
			
			theater = parse_theater(div)
			movie[:theaters].push(theater)
			
		end

		#p movie
		$schedule.push movie
		
	end
end


def get_time
	$movies.each do |id, name|
		sleep( 1 )
		get_content(id, name)
		#return

	end
end


def get_movies
	Net::HTTP.start($URL,80) do |http|
		rsp = http.get('/home/movie_homepage.html')
		html_doc = Nokogiri::HTML(rsp.body)
		
		html_doc.css('select[name=film_id] option').each do |opt|
			next if opt['value'].strip == ""
			$movies[ opt['value'] ] = opt.content
		end
	end
end


def main
		
	begin
		get_movies
		get_time
		#puts $schedule.to_json

		uri = URI('http://127.0.0.1:3000/movie/update_schedules.json')
		res = Net::HTTP.post_form(uri, { data: $schedule.to_json})
		puts res.body

	rescue Exception => msg  
		p msg

	end

end

main if $0==__FILE__