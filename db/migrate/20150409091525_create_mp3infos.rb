class CreateMp3infos < ActiveRecord::Migration
  def change
    create_table :mp3infos do |t|
        t.string :path,      :null=>false
        t.string :file_name, :null=>false
        t.string :file_type, :null=>false
        t.string :md5,       :null=>false
        t.string :genre
        t.string :album_artist
        t.string :album
        t.string :artist
        t.string :track
        t.string :title

        t.timestamps
    end

    add_index :mp3infos, :file_name
    add_index :mp3infos, :md5
    add_index :mp3infos, :genre
    add_index :mp3infos, :album_artist
    add_index :mp3infos, :album
    add_index :mp3infos, :artist
    add_index :mp3infos, :title
  end
end
