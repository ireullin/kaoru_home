class DropMp3info < ActiveRecord::Migration
    def change
        drop_table :mp3infos
    end
end
