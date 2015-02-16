class AddEnablePhotoalbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :enable, :integer
  end
end
