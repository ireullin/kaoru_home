class PhotoAlbumController < ApplicationController
		
	before_action :flickr_info

	def index
		cookies[:api_key] = @api_key
		cookies[:photoset_id] = @photoset_id


	end





	private
	######################################################
	#
	#s	小正方形 75x75
	#q	large square 150x150
	#t	縮圖，最長邊為 100
	#m	小，最長邊為 240
	#n	small, 320 on longest side
	#-	中等，最長邊為 500
	#z	中等尺寸 640，最長邊為 640
	#c	中等尺寸 800，最長邊為 800†
	#b	大尺寸，最長邊為 1024*
	#h	大型 1600，長邊 1600†
	#k	大型 2048，長邊 2048†
	#o	原始圖片, 根據來源格式可以是 jpg、gif 或 png
	#
	########################################################
	def photo_url(i, size)
		return "https://farm#{i['farm']}.staticflickr.com/#{i['server']}/#{i['id']}_#{i['secret']}_#{size}.jpg"
	end


	def flickr_info
		@api_key = "eba448bcd6c37026451a079690eff107"
		@shared_secret = "861d1cc1a0791a58"
		@photoset_id = '72157648727044669'
		@user_id = '127432547@N03'
	end
end
