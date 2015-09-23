class VideoStreamController < ApplicationController
    def index

        movie_path = '/kaoru_videos/videos'

        @video_files = []
        Dir.foreach(Rails.public_path.to_s+movie_path) do |f|
            next if f[0]=='.'
            @video_files.push(movie_path + '/' + f)
        end
    end
end
