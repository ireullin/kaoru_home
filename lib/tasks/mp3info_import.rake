require 'taglib'
require "mp3info"
require 'digest'
require 'iconv'
require 'rchardet'

namespace :mp3info_import do


    desc "full scan the music directory"
    task full_import: :environment do

        $ic = Iconv.new("cp950", "utf-8")
        #$ic = Iconv.new("utf-8", "big5")

        music_path = File.join(Rails.public_path,'music','{cd,nocd}','**','*.{mp3}')
        #puts music_path
        Dir.glob(music_path) do |f|
            begin
                get_mp3info2 f
            rescue Exception => e
                p e
            end
        end
    end


    def get_mp3info2(file)

        info =Mp3Info.open(file, :encoding => 'cp950')
        arr = [
            File.basename(file),
            Digest::MD5.file(file).hexdigest,
            info.tag.title,
            CharDet.detect(info.tag.title)['encoding'],
            info.tag.artist.encoding,
            info.tag.album.encoding,
            info.tag.year,
            info.tag.tracknum,
            info.tag.genre_s,
            info.tag.genre_s.bytes.to_a,
            CharDet.detect(info.tag.genre_s)['encoding'],
            info.tag.comment
        ]

        p arr

    end






    def get_mp3info(file)
        TagLib::FileRef.open(file) do |info|
            arr = [
                info.tag.title,
                info.tag.artist,
                info.tag.album,
                info.tag.year,
                info.tag.track,
                info.tag.genre,
                CharDet.detect(info.tag.genre)['encoding'],
                info.tag.comment,
            ]

            p arr
        end
    end



end
