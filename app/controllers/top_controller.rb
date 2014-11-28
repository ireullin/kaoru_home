class TopController < ApplicationController
  	def index
  		@weather = Weather.all
	end


	def login
		respond_to do |format|
       		format.html { render :login, layout: false }
       	end
	end


	def logout
		session.delete(:account)
		redirect_to request.env['HTTP_REFERER']
	end


	def varify
		if( params[:account]!="ireullin" || params[:password]!="0933726835")
			respond_to do |format|
        		format.any { render file: "#{Rails.root}/public/500.html",  status: 500, layout: false }
      		end
      	else
      		session[:account] = params[:account]
	      	redirect_to params[:url]
	    end
	end


	def first
		respond_to do |format|
       		format.html { render :first, layout: false }
       	end
	end


	def record_name
		record = IpOwner.new
		record.name = params[:name]
		record.ip = request.remote_ip
		record.reason = "keypress"
		record.save

		cookies.permanent[:name] = params[:name]

      	redirect_to params[:url]
	end
end
