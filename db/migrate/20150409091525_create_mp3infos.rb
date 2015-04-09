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

    add_index :mp3info, :file_name
    add_index :mp3info, :md5
    add_index :mp3info, :genre
    add_index :mp3info, :album_artist
    add_index :mp3info, :album
    add_index :mp3info, :artist
    add_index :mp3info, :title
  end
end
