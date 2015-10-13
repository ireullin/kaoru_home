class VideoStreamController < ApplicationController
    def index

        movie_path = '/kaoru_videos/videos'

        @files = []
        bf_files = []
        flag = false
        Dir.foreach(Rails.public_path.to_s+movie_path) do |f|
            next if f[0]=='.'

            id = File.basename(f,'.*')
            flag = true if !params[:id].nil? and params[:id]==id and !flag

            unless flag
                bf_files << id
            else
                @files << id
            end
        end

        @files.concat(bf_files)

        # move the first to last
        first = @files.shift
        @files << first

        if params[:id].nil?
            @movie_url = "#{movie_path}/#{@files[-1]}.mp4"
        else
            @movie_url = "#{movie_path}/#{params[:id]}.mp4"
        end
    end
end
