namespace :video do
	desc "TODO"
  	task generate_images: :environment do

  		image_path = Dir.pwd+'/public/kaoru_videos/images'
  		video_path = Dir.pwd+'/public/kaoru_videos/videos'
  		tmp_path = Dir.pwd+'/public/kaoru_videos/tmp'

  		Dir.foreach(video_path) do |f|
  			next if f[0]=='.'

        basename = File.basename(f,'.*')

  			ori_video_file = video_path + '/' + basename + '.mp4'
        basename.gsub!('.','_')
        basename.gsub!("\s",'_')
        basename.gsub!(';','_')
        basename.gsub!(':','_')
        basename.gsub!('~','_')

        video_file = video_path + '/' + basename + '.mp4'
  			image_file = image_path + '/' + basename + '.jpg'

        next if File.exist?(image_file)

        `mv "#{ori_video_file}" "#{video_file}"`
  			`rm #{tmp_path}/* `
  			puts `avconv -i "#{video_file}" -vsync 1 -r 0.1 -an -y -qscale 1 -s 192x108 "#{tmp_path}/out_%04d.jpg"`
  			`mv "#{tmp_path}/out_0001.jpg" "#{image_file}" `
  			`rm #{tmp_path}/* `
  		end

  	end
end
