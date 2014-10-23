#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'rexml/document'



def get_date(ele)
	return ele.parent.attributes['start'].split('T')[0]
end


def insert_to_db(data)
	
	uri = URI('http://127.0.0.1/weather/update')
	res = Net::HTTP.post_form(uri, { data: data.to_json})
	puts res.body
end


def parse_data(ele, city)
	
	data = Hash.new

	ele.elements.each('weather-elements/Wx/time/text') do |child|
		data[ get_date(child) ] = { des: child.text, city: city }
	end

	ele.elements.each('weather-elements/MaxT/time/value') do |child|
		data[ get_date(child) ][:max] = child.text
	end

	ele.elements.each('weather-elements/MinT/time/value') do |child|
		data[ get_date(child) ][:min] = child.text
	end

	insert_to_db data
	#puts data.to_json
end


def find_city(content)
	_doc = REXML::Document.new(content)
	_doc.elements.each('fifowml/data/location/name') do |ele|
   		
   		if ele.text == '臺北市'
   			parse_data( ele.parent, ele.text )
   			break
   		end
	end
end


def main
	Net::HTTP.start('opendata.cwb.gov.tw',80) do |http|
		_rsp = http.get('/opendata/MFC/F-C0032-003.xml')
		find_city _rsp.body
	end

end


main if $0==__FILE__


