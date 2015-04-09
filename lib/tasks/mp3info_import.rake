require "mp3info"
require 'digest'


namespace :mp3info_import do


    desc "full scan the music directory"
    task full_import: :environment do

        music_path = File.join(Rails.public_path,'music','{cd,nocd}','**','*.{mp3}')

        full_data = []

        Dir.glob(music_path) do |f|
            full_data << get_mp3info(f)
        end

        full_data.each do |row|
            Mp3info.new(row).save
        end
    end


    def get_mp3info(file)

        info =Mp3Info.open(file)
        #p info
        #return nil
        row = {
            path:         File.dirname(file).gsub(Rails.public_path.to_s , '') ,
            file_name:    File.basename(file),
            file_type:    File.extname(file).gsub('.',''),
            md5:          Digest::MD5.file(file).hexdigest,
            genre:        info.tag.genre_s,
            album_artist: info.tag2["TPE2"],
            album:        info.tag.album,
            artist:       info.tag.artist,
            track:        info.tag.tracknum,
            title:        info.tag.title,
        }

        return row
    end




end
