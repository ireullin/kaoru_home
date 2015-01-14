namespace :weather do
	desc "TODO"
  	task week: :environment do

  		uri = URI('http://opendata.cwb.gov.tw/opendata/MFC/F-C0032-003.xml')
		rsp = Net::HTTP.get_response(uri)
		#puts rsp.body

		html_doc = Nokogiri::HTML(rsp.body)
		
		data = Hash.new

		html_doc.css('locationname').each do |ele1|
			next unless ele1.content.strip == "臺北市"
			
			ele1.parent.css('elementname').each do |ele2|

				0.upto(6) do |i|
					key = ele2.parent.css('starttime')[i].content[0,10]
					data[key] = [] unless data.has_key?(key)
					data[key] << ele2.parent.css('parametername')[i].content
				end
			end
		end

		p data

		Weather.delete_all
		data.each do |k,v|
			rc = Weather.new
			rc.weather_date = k
			rc.des = v[0]
			rc.max = v[1]
			rc.min = v[2]
			rc.city = '臺北市'
			rc.created_at = Time.now
			rc.updated_at = Time.now
			rc.save
		end
  	end
end
