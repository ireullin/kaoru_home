namespace :video do
    desc "TODO"
    task convert_videos: :environment do

        src_path = Dir.pwd+'/public/kaoru_videos/src'
        Dir.foreach(src_path) do |f|

            next if f[0]=='.'
            convert_mp4(src_path+'/'+f)
        end

        #3gp
        #puts `avconv -i "#{src}" -acodec copy "#{dst}"`
        #mov
        #puts `avconv -i "#{src}" -acodec libmp3lame "#{dst}"`
    end


    def convert_mp4(src_file)

        file_name = replace_name(File.basename(src_file, ".*"))
        ext_name = File.extname(src_file)
        dst_file = Dir.pwd+'/public/kaoru_videos/videos/'+file_name+'.mp4'
        img_file = Dir.pwd+'/public/kaoru_videos/images/'+file_name+'.jpg'

        return if File.exist?(dst_file)
        #puts src_file
        #puts dst_file
        #return
        puts "generating #{file_name}.mp4"
        if ext_name == '.mov'
            `avconv -i "#{src_file}" -s 1024x768 -acodec libmp3lame -vf transpose "#{dst_file}"`
        else
            `avconv -i "#{src_file}" -s 1024x768 -acodec copy -vf transpose "#{dst_file}"`
        end

        puts "generating #{file_name}.jpg"
        generate_image(dst_file, img_file)
    end


    def generate_image(src, dst)

        tmp_path = Dir.pwd+'/public/kaoru_videos/tmp'

        `rm #{tmp_path}/* `
        `avconv -i "#{src}" -vsync 1 -r 0.1 -an -y -qscale 1 -s 152x208 "#{tmp_path}/out_%04d.jpg"`
        `mv "#{tmp_path}/out_0001.jpg" "#{dst}" `
        `rm #{tmp_path}/* `
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
