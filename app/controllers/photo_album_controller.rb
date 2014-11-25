class PhotoAlbumController < ApplicationController

	before_action :check_session, :except => [:index]

	def index
		@data = PhotoAlbum.where(path: params[:path]).first
		cookies[:api_key] = @data.api_key
		cookies[:photoset_id] = @data.photoset_id
	end


	def manage
		@photo_albums = PhotoAlbum.all
	end


	def new
		respond_to do |format|
       		format.html { render :new, layout: false }
       	end
	end


	def create
	    @photo_albums = PhotoAlbum.new
	    @photo_albums.path = params[:path]
		@photo_albums.name = params[:name]
		@photo_albums.yahoo_account = params[:yahoo_account]
		@photo_albums.api_key = params[:api_key]
		@photo_albums.shared_secret = params[:shared_secret]
		@photo_albums.photoset_id = params[:photoset_id]
		@photo_albums.user_id = params[:user_id]

	    respond_to do |format|
	      	if @photo_albums.save
	        	format.html { redirect_to action: 'manage' }
	      	else
		        format.html { render :new }
		    end
	    end
	end


	def edit
		@data = PhotoAlbum.where( path: params[:path] ).first

		respond_to do |format|
       		format.html { render :new, layout: false }
       	end
	end


	def update
		@photo_albums = PhotoAlbum.where(:path => params[:path])
	    @photo_albums.update_all(
			name: params[:name],
			yahoo_account: params[:yahoo_account],
			api_key: params[:api_key],
			shared_secret: params[:shared_secret],
			photoset_id: params[:photoset_id],
			user_id: params[:user_id],
			updated_at: Time.now.localtime.strftime("%Y-%m-%d %H:%M:%S")
		)

	    respond_to do |format|
        	format.html { redirect_to action: 'manage', notice: 'OK' }
	    end
	end


	def delete
		PhotoAlbum.where(:path => params[:path]).delete_all

		respond_to do |format|
        	format.html { redirect_to action: 'manage' }
	    end
	end


	private
	def check_session
		if session[:account].blank?
			respond_to do |format|
        		format.any { render file: "#{Rails.root}/public/500.html",  status: 500, layout: false }
      		end
	    end
	end
end
