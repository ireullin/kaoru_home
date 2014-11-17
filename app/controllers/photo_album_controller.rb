class PhotoAlbumController < ApplicationController

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


	end

end
