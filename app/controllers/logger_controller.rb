class LoggerController < ApplicationController
	def index
		@histories = LoginHistory.order("created_at DESC").limit(30)
		@count_ip = LoginHistory.count_ip
		@count_path = LoginHistory.count_path
	end
end
