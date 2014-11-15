class CreatePhotoAlbums < ActiveRecord::Migration
  	def change
		create_table :photo_albums, :id => false do |t|
			t.string :path
			t.string :name
			t.string :yahoo_account
			t.string :api_key
			t.string :shared_secret
			t.string :photoset_id
			t.string :user_id
			t.datetime :created_at
			t.datetime :updated_at
		end

		add_index :photo_albums, :path, :unique => true

	end
end
