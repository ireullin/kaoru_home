class VideoStreamController < ApplicationController
    def index

        movie_path = '/kaoru_videos/videos'

        @files = []
        Dir.foreach(Rails.public_path.to_s+movie_path) do |f|
            next if f[0]=='.'
            @files << File.basename(f,'.*')
        end

        if params[:id].nil?
            @movie_url = "#{movie_path}/#{@files[0]}.mp4"
        else
            @movie_url = "#{movie_path}/#{params[:id]}.mp4"
        end
    end
end
