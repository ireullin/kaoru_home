module TopHelper
	def news(subtitle)

		#row = IpOwner.where(ip: request.remote_ip).first
		#if row.blank?
			title = "最新消息"
		#else
		#	title = row.name + " 你好"
		#end
		

		%Q(
		<div class="alert alert-warning alert-dismissible" role="alert">
  		<button type="button" class="close" data-dismiss="alert">
  			<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
  		</button>
  		<strong>#{title}</strong><br>
  		#{subtitle}
		</div>
		).html_safe
	end
end
