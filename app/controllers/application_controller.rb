class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

  	def must_login
		if session[:account].blank?
			respond_to do |format|
        		format.any { render file: "#{Rails.root}/public/500.html",  status: 500, layout: false }
      		end
	    end
	end


end
