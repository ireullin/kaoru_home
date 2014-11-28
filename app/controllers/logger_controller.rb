class LoggerController < ApplicationController
	
	before_action :check_session

	def index
		@histories = LoginHistory.order("created_at DESC").limit(30)
		@count_ip = LoginHistory.count_ip
		@count_path = LoginHistory.count_path
		@ipowner = IpOwner.all
	end

	private
	def check_session
		if session[:account].blank?
			respond_to do |format|
        		format.any { render file: "#{Rails.root}/public/500.html",  status: 500, layout: false }
      		end
	    end
	end
	
end
