namespace :video do
	desc "TODO"
  	task generate_images: :environment do

  		image_path = Dir.pwd+'/public/kaoru_videos/images'
  		video_path = Dir.pwd+'/public/kaoru_videos/videos'
  		tmp_path = Dir.pwd+'/public/kaoru_videos/tmp'

  		Dir.foreach(video_path) do |f|
  			next if f[0]=='.'

  			video_file = video_path + '/' + f
  			image_file = image_path + '/' + File.basename(f,'.*') + '.jpg'

  			next if File.exist?(image_file)

  			`rm #{tmp_path}/* `
  			puts `avconv -i "#{video_file}" -vsync 1 -r 0.1 -an -y -qscale 1 -s 192x108 "#{tmp_path}/out_%04d.jpg"`
  			`mv "#{tmp_path}/out_0001.jpg" "#{image_file}" `
  			`rm #{tmp_path}/* `
  		end

  	end
end
