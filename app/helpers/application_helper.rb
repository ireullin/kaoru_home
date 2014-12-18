module ApplicationHelper
	def kaminari_with_dropdown(rec, dropdown: true)

		buf = Array.new

		buf.push '<ul class="nav navbar-nav">'
	        
	    clone_params =  params.clone
	    clone_params[:page] = 1
	    
	    buf.push '<li><a href="' + full_url(url_for(clone_params)) + '">First</a></li>'
	        
	    unless rec.first_page?
	        clone_params[:page] = rec.prev_page
	    else
	    	clone_params[:page] = 1
	    end

	    buf.push '<li><a href="' + full_url(url_for(clone_params)) + '">Prev</a></li>'

	    if dropdown
	    	buf.push '<li class="dropdown">'
	    else
	    	buf.push '<li class="dropup">'
	    end

	    buf.push '<a href="#" class="dropdown-toggle" data-toggle="dropdown">Page ' + params[:page] + '<span class="caret"></span></a>'
	    buf.push '<ul class="dropdown-menu" role="menu">'
	    1.upto( rec.total_pages ) do |i|
	        clone_params[:page] = i
	        buf.push '<li><a href="' + full_url(url_for(clone_params)) + '">' + i.to_s + '</a></li>'
	    end
	    
	    buf.push '</ul>'
	    buf.push '</li>'

        unless rec.last_page?
            clone_params[:page] = rec.next_page
        else
        	clone_params[:page] = rec.total_pages
        end

        buf.push '<li><a href="' + full_url(url_for(clone_params)) + '">Next</a></li>'
        

	    clone_params[:page] = rec.total_pages
	    buf.push '<li><a href="' + full_url(url_for(clone_params)) + '">Last</a></li>'
	    buf.push '</ul>'

	    return buf.join('').html_safe
	end

	
	def record_login_history
		data = LoginHistory.new
    	data.ip = request.remote_ip
    	data.agent = request.env['HTTP_USER_AGENT']
    	data.path = request.env['PATH_INFO']
    	data.save
	end


	def set_user_cookie?
		 is_first = false

	    if( request.remote_ip != "127.0.0.1" and request.remote_ip !~ /192\.168\.\d{1,3}\.\d{1,3}/  )
	        record = IpOwner.where(ip: request.remote_ip)

	        if( record.empty? )
	            unless( cookies[:name].blank? )
	                new_record = IpOwner.new
	                new_record.name = cookies.signed[:name]
	                new_record.ip = request.remote_ip
	                new_record.reason = "cookie"
	                new_record.save 
	            else
	                is_first = true
	            end
	        else
	            if( cookies[:name].blank? )
	                cookies.permanent.signed[:name] = record.first.name
	            end
	        end
	    end

	    return is_first
	end


	def full_url(path)
		if path[0]=='/'
			return root_url + path[1..-1]
		else
			return root_url + path
		end
	end
end
