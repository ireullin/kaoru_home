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
			
			rec = VarifyPasswordHistory.new
			rec.account = params[:account]
			rec.password = params[:password]
			rec.result = 1
			rec.ip = request.remote_ip
			rec.agent = request.env['HTTP_USER_AGENT']
			rec.save

			redirect_to '/error.html'
      	else
      		
      		rec = VarifyPasswordHistory.new
			rec.account = params[:account]
			rec.password = 'itsok'
			rec.result = 0
			rec.ip = request.remote_ip
			rec.agent = request.env['HTTP_USER_AGENT']
			rec.save

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

		if params[:name].blank?
			redirect_to '/error.html' 
			return
		end

		IpOwner.find_or_initialize_by(ip: request.remote_ip ) do |record|
			record.name = params[:name]
			record.ip = request.remote_ip
			record.reason = "keypress"
			record.save
		end

		cookies.permanent.signed[:name] = params[:name]

      	redirect_to params[:url]
	end
end
