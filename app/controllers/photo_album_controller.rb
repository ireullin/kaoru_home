class PhotoAlbumController < ApplicationController

	before_action :must_login, :except => [:index]

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
		@photo_albums.updated_at = Time.now.localtime.strftime("%Y-%m-%d %H:%M:%S")
		@photo_albums.created_at = Time.now.localtime.strftime("%Y-%m-%d %H:%M:%S")
		

	    respond_to do |format|
	    	if @photo_albums.save
        		format.html { redirect_to action: 'manage' }
        	else
        		flash[:notice] = @photo_albums.errors.full_messages
        		format.html { redirect_to action: 'manage'  }
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
	    	flash[:notice] = @photo_albums.errors.full_messages if @photo_albums.try(:errors)
        	format.html { redirect_to action: 'manage', notice: 'OK' }
	    end
	end


	def delete
		PhotoAlbum.where(:path => params[:path]).delete_all

		respond_to do |format|
        	format.html { redirect_to action: 'manage' }
	    end
	end

end
