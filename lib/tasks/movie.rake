namespace :movie do

    URL = 'www.atmovies.com.tw'
    SOLR = 'http://192.168.1.222:8983/solr/movie_schedules'

    desc "import data to solr form db"
    task solr_import: :environment do
        MovieSchedules.all.each do |r|
            #p r['movie_id']
            body = {
                'add' => {
                    'doc' =>{
                        'MOVIE_ID' => r['movie_id'],
                        'NAME' => r['name'],
                        'SUMMARY' => r['summary'],
                        'RUNTIME' => r['runtime'],
                        'SCHEDULES' => r['schedules'],
                        'CREATED_AT' => r['created_at']
                    }
                }
            }

            rsp = http_post(SOLR+"/update", body)
            puts r['name'] + " respond " + rsp.to_json
        end
    end

    def http_post(url, body)
        json_headers = {"Content-Type" => "application/json; charset=utf-8", "Accept" => "application/json" }

        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.continue_timeout = 3600
        http.read_timeout = 3600

        rsp = http.post(uri.path, body.to_json, json_headers)
        rsp_obj = JSON.parse(rsp.body)

        return rsp_obj
    end


    def clear_solr
        [
            SOLR+"/update?stream.body=%3Cdelete%3E%3Cquery%3E*:*%3C/query%3E%3C/delete%3E",
            SOLR+"/update?stream.body=%3Ccommit/%3E"
        ].each{|url|
            Net::HTTP.get(URI(url))
        }
    end


    desc "download movies from atmovies"
    task download: :environment do
        movies = get_movies
        schedules = get_schedules(movies)
        #p schedules

        MovieSchedules.delete_all
        schedules.each do | movie |
            row = MovieSchedules.new
            row.movie_id = movie[:movie_id]
            row.name = movie[:name]
            row.summary = movie[:summary]
            row.runtime = movie[:runtime]
            row.schedules = movie[:theaters].to_json
            row.created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
            row.save
        end
    end


    def get_schedules(movies)
        schedules = Array.new
        movies.each do |id, name|
            begin
                theaters = get_theaters(id, name)
                fullname,runtime,summary = get_summary(id)
                schedules << { movie_id: id, name: fullname, summary:summary, runtime:runtime, theaters: theaters }
                puts "#{fullname} downloaded"
                #break
            rescue Exception => msg
                puts "#{name} download failed"
            end
            sleep(2)
        end
        return schedules
    end


    def get_movies
        movies = Hash.new
        Net::HTTP.start(URL,80) do |http|
            rsp = http.get('/home/movie_homepage.html')
            html_doc = Nokogiri::HTML(rsp.body)

            html_doc.css('select[name=film_id] option').each do |opt|
                next if opt['value'].strip == ""
                movies[ opt['value'] ] = opt.content
            end
        end
        return movies
    end

    def remove_noises(str)
        return str.gsub(/[\r\n\t\s]/,'')
    end


    def parse_theater(c)

        #p div.css("a")[0].content.gsub(/[\r\n\t ]/,'')
        data = { theater: '', times: [] }

        c.css('li').each do |row|

            case row['class']
            when 'theaterTitle'
                data[:theater] += remove_noises(row.content)
            when 'filmVersion'
                data[:theater] += remove_noises(row.content)
            when nil
                data[:times] << remove_noises(row.content)
            when ''
                data[:times] << remove_noises(row.content)
            end

        end

        return data
    end


    def get_theaters(id, name)
        theaters = []
        Net::HTTP.start(URL,80) do |http|

            rsp = http.get("/showtime/#{id}/a02/")
            #p rsp.body.to_s

            html_doc = Nokogiri::HTML(rsp.body)

            html_doc.css('#filmShowtimeBlock')[0].css('ul').each do |c|
                theaters << parse_theater(c)
            end

            #p theaters
            return theaters
        end
    end


    def get_summary(id)
        Net::HTTP.start(URL,80) do |http|

            rsp = http.get("/movie/#{id}/")
            #p rsp.body.to_s

            html_doc = Nokogiri::HTML(rsp.body)

            summary = html_doc.css('.sub_content')[0].content
            runtime = html_doc.css('.runtime')[0].content
            fullname = html_doc.css('.filmTitle')[0].content.strip

            #p schedule
            return fullname,remove_noises(runtime),remove_noises(summary)
        end
    end
end
