class LoggerController < ApplicationController
	
	before_action :must_login

	def index
		@histories = LoginHistory.history_with_name
		@count_ip = LoginHistory.count_ip
		@count_path = LoginHistory.count_path
		@ipowner = IpOwner.all
	end

end
