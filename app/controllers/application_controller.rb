class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

  	def must_login
		if session[:account].blank?
			redirect_to( full_url 'error.html' )
	    end
	end

	def full_url(path)
		if path[0]=='/'
			return root_url + path[1..-1]
		else
			return root_url + path
		end
	end
end
