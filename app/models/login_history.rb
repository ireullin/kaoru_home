class LoginHistory < ActiveRecord::Base

	def self.count_ip
		find_by_sql """
		SELECT COUNT( * ) AS count, a.ip, b.name
		FROM login_histories a
		LEFT JOIN ip_owners b ON a.ip = b.ip
		GROUP BY a.ip
		ORDER BY count DESC 
		"""
	end

	def self.count_path
		find_by_sql "select count(*) as count, path from login_histories group by path order by count desc;"
	end

	def self.history_with_name
		find_by_sql """
		SELECT a . * , b.name, b.reason
		FROM login_histories a
		LEFT JOIN ip_owners b ON a.ip = b.ip
		ORDER BY created_at DESC 
		LIMIT 0 , 50
		"""
	end

end
