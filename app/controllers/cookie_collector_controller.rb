class CookieCollectorController < ApplicationController

	def empty_img

		path = Rails.root.join("app", "assets", "images", 'a.png').to_s
		respond_to do |format|
			format.png { render :text => open(path, "rb").read }
		end
	end
end
