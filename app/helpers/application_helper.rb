module ApplicationHelper
	def kaminari_with_dropdown(rec)

		buf = Array.new

		buf.push '<ul class="nav navbar-nav">'
	        
	    clone_params =  params.clone
	    clone_params[:page] = 1
	    
	    buf.push '<li><a href="' + url_for(clone_params) + '">First</a></li>'
	        
	    unless rec.first_page?
	        clone_params[:page] = rec.prev_page
	    else
	    	clone_params[:page] = 1
	    end

	    buf.push '<li><a href="' + url_for(clone_params) + '">Prev</a></li>'

	    buf.push '<li class="dropdown">'
	    buf.push '<a href="#" class="dropdown-toggle" data-toggle="dropdown">Page ' + params[:page] + '<span class="caret"></span></a>'
	    buf.push '<ul class="dropdown-menu" role="menu">'
	    1.upto( rec.total_pages ) do |i|
	        clone_params[:page] = i
	        buf.push '<li><a href="' + url_for(clone_params) + '">' + i.to_s + '</a></li>'
	    end
	    
	    buf.push '</ul>'
	    buf.push '</li>'

        unless rec.last_page?
            clone_params[:page] = rec.next_page
        else
        	clone_params[:page] = rec.total_pages
        end

        buf.push '<li><a href="' + url_for(clone_params) + '">Next</a></li>'
        

	    clone_params[:page] = rec.total_pages
	    buf.push '<li><a href="' + url_for(clone_params) + '">Last</a></li>'
	    buf.push '</ul>'

	    return buf.join('').html_safe
	end
end
