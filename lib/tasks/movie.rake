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
                        'CREATED_AT' => r['created_at'],
                        'DIRECTORS' => JSON.parse(r['directors']),
                        'DRAMATISTS' => JSON.parse(r['dramatists']),
                        'ACTORS' => JSON.parse(r['actors'])
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

    desc "clear solr"
    task solr_clear: :environment do
        [
            SOLR+"/update?stream.body=%3Cdelete%3E%3Cquery%3E*:*%3C/query%3E%3C/delete%3E",
            SOLR+"/update?stream.body=%3Ccommit/%3E"
        ].each{|url|
            puts Net::HTTP.get(URI(url))
        }
    end

##########################################################################################

    desc "download movies from atmovies"
    task download: :environment do
        movies = get_movies
        schedules = get_schedules(movies)
        #p schedules

        MovieSchedules.delete_all
        schedules.each do | movie |
            row = MovieSchedules.new
            row.movie_id = movie[:movie_id]
            row.name = movie[:fullname]
            row.summary = movie[:summary]
            row.runtime = movie[:runtime]
            row.schedules = movie[:theaters].to_json
            row.directors = movie[:directors].to_json
            row.dramatists = movie[:dramatists].to_json
            row.actors = movie[:actors].to_json
            row.created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
            row.save
        end
    end


    def get_schedules(movies)
        schedules = Array.new
        movies.each do |id, name|
            begin
                details = get_details(id)
                details[:movie_id] = id
                details[:theaters] = get_theaters(id)
                #p details
                schedules << details

                puts "#{details[:fullname]} downloaded"
                #break
            rescue Exception => msg
                puts "#{name} download failed (#{msg})"
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





    def parse_theater(c)

        data = { theater: '', times: [] }

        c.css('li').each do |row|

            case row['class']
            when 'theaterTitle'
                data[:theater] += row.content.remove_noises
            when 'filmVersion'
                data[:theater] += row.content.remove_noises
            when nil
                data[:times] << row.content.remove_noises
            when ''
                data[:times] << row.content.remove_noises
            end

        end

        return data
    end


    def get_theaters(id)
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


    def get_details(id)
        details = { directors:[], dramatists:[], actors:[] }
        Net::HTTP.start(URL,80) do |http|

            rsp = http.get("/movie/#{id}/")
            #p rsp.body.to_s

            html_doc = Nokogiri::HTML(rsp.body)

            details[:summary] = html_doc.css('.sub_content')[0].content.remove_noises
            details[:runtime] = html_doc.css('.runtime')[0].content.remove_noises
            details[:fullname] = html_doc.css('.filmTitle')[0].content.strip

            html_doc.css('ul').each do |ul|
                next unless ul.content.include?('導演：')

                flag = nil
                ul.css('li').each do |li|
                    line = li.content.remove_noises.gsub(/more$/,'')

                    case line
                    when /^導演：/
                        flag = :directors
                        line.gsub!(/^導演：/,'')
                    when /^編劇：/
                        flag = :dramatists
                        line.gsub!(/^編劇：/,'')
                    when /^演員：/
                        flag = :actors
                        line.gsub!(/^演員：/,'')
                    end

                    #puts flag,line
                    details[flag].push(line) unless flag==nil

                end
                break
            end

            return details
        end
    end


    class String
        def remove_noises
            gsub(/[\r\n\t\s]/,'')
        end
    end
end
