class LoggerController < ApplicationController
	
	before_action :must_login

	def index
		@count_ip = LoginHistory.count_ip
		@count_path = LoginHistory.count_path
		@ipowner = IpOwner.order(:name)
	end


	def history
		@histories = LoginHistory
			.select('login_histories.* , ip_owners.name, ip_owners.reason')
			.joins('LEFT JOIN ip_owners ON login_histories.ip = ip_owners.ip')
			.order('login_histories.created_at DESC')
			.page( params[:page] ).per(50)
	end

end
