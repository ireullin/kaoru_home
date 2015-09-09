class VideoStreamController < ApplicationController
    def index

        vedio_path = 'kaoru_videos'
        movie_path = Rails.public_path.to_s + '/'+vedio_path+'/*'
        #respond_to {|format| format.any { render json: {path: movie_path } } }

        @video_files = []
        Dir.glob(movie_path) do |file|
            @video_files.push(vedio_path + '/' +File.basename(file))
        end
    end
end
