require 'net/http'
require 'nokogiri'
#require 'iconv'


$URL = 'www.atmovies.com.tw'
$movies = Hash.new
#$ic = Iconv.new('UTF-8', 'BIG5')

def get_content(id)
	Net::HTTP.start($URL,80) do |http|
		rsp = http.get("/showtime/showtime.asp?film_id=#{id}&area=a02")
		
		puts rsp.body.decode('big5') #.encode('UTF-8')  

		#html_doc = Nokogiri::HTML(rsp.body)
		#html_doc.css('.showtime01').each do |div|
		#	p div.content
		#end
	end
end


def get_time
	$movies.each do |id, name|
		get_content id
		return
	end
end


def get_movies
	Net::HTTP.start($URL,80) do |http|
		rsp = http.get('/home/movie_homepage.html')
		html_doc = Nokogiri::HTML(rsp.body)
		
		html_doc.css('select[name=film_id] option').each do |opt|
			$movies[ opt['value'] ] = opt.content
		end
	end
end


def main
	get_movies
	#p $movies
	get_time
end

main if $0==__FILE__