namespace :video do
    desc "TODO"
    task convert_videos: :environment do

        src_path = Dir.pwd+'/public/kaoru_videos/src'
        Dir.foreach(src_path) do |f|

            next if f[0]=='.'
            convert_mp4(src_path+'/'+f)
        end

    end


    def convert_mp4(src_file)

        file_name = replace_name(File.basename(src_file, ".*"))
        ext_name = File.extname(src_file)
        dst_file = Dir.pwd+'/public/kaoru_videos/videos/'+file_name+'.mp4'
        img_file = Dir.pwd+'/public/kaoru_videos/images/'+file_name+'.jpg'

        return if File.exist?(dst_file)

        w,h = get_size(src_file)
        if w.nil? or h.nil?
            puts "#{src_file} couldn't get video's information"
            return
        end

        w,h = scale_size(w,h)

        puts "generating #{file_name}.mp4"
        if ext_name == '.mov'
            `avconv -i "#{src_file}" -s #{w}x#{h} -acodec libmp3lame "#{dst_file}" 2>/dev/null`
        else
            `avconv -i "#{src_file}" -s #{w}x#{h} -acodec copy "#{dst_file}" 2>/dev/null`
        end

        puts "generating #{file_name}.jpg"
        generate_image(dst_file, img_file, w, h)
    end


    def scale_size(w,h)
        rate1 = w/1024.0
        rate2 = h/768.0
        rate = [rate1,rate2].max
        return (w/rate).to_i ,(h/rate).to_i
    end


    def get_size(src)

        begin
            json_str = `avprobe -of json -show_streams #{src} 2>/dev/null`
            json_obj = JSON.parse(json_str)

            json_obj['streams'].each do |n|
                next if n['width'].nil?
                next if n['height'].nil?
                return n['width'],n['height']
            end

            return nil

        rescue
            return nil
        end
    end


    def generate_image(src, dst, w, h)

        tmp_path = Dir.pwd+'/public/kaoru_videos/tmp'

        `rm #{tmp_path}/* 2>/dev/null`
        `avconv -i "#{src}" -vsync 1 -r 0.1 -an -y -qscale 1 -s #{w/3}x#{h/3} "#{tmp_path}/out_%04d.jpg" 2>/dev/null`
        `mv "#{tmp_path}/out_0001.jpg" "#{dst}" 2>/dev/null`
        `rm #{tmp_path}/* 2>/dev/null`
    end


    def replace_name(name)
        tmp = name
        tmp.gsub!('.','_')
        tmp.gsub!("\s",'_')
        tmp.gsub!(';','_')
        tmp.gsub!(':','_')
        tmp.gsub!('~','_')
        return tmp
    end

end
