class PhotoAlbum < ActiveRecord::Base
	validates_presence_of :name, :yahoo_account, :api_key, :shared_secret, :photoset_id, :user_id, :updated_at
end
