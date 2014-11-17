class LoginHistory < ActiveRecord::Base

	def self.count_ip
		find_by_sql "select count(*) as count, ip from login_histories group by ip order by count desc;"
	end

	def self.count_path
		find_by_sql "select count(*) as count, path from login_histories group by path order by count desc;"
	end
end
