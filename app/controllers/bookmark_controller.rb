class BookmarkController < ApplicationController
    
    before_action :must_login

    
    def manage
        @bookmarks = Bookmarks.all
    end


    def new
        respond_to do |format|
            format.html { render :new, layout: false }
        end
    end


    def create
        @bookmarks = Bookmarks.new
        @bookmarks.bookmark_name = params[:name]
        @bookmarks.bookmark_url = params[:url]
        @bookmarks.enable = params[:enable]
   

        respond_to do |format|
            if @bookmarks.save
                format.html { redirect_to(full_url 'bookmark/manage') }
            else
                flash[:notice] = @bookmarks.errors.full_messages
                format.html { redirect_to(full_url 'bookmark/manage') }
            end
        end
    end


    def edit
        @data = Bookmarks.where( id: params[:id] ).first

        respond_to do |format|
            format.html { render :new, layout: false }
        end
    end


    def update
        @photo_albums = Bookmarks.where(:id => params[:id])
        @photo_albums.update_all(
            bookmark_name: params[:name],
            bookmark_url: params[:url],
            enable: params[:enable],
            updated_at: Time.now.strftime("%Y-%m-%d %H:%M:%S")
        )

        respond_to do |format|
            flash[:notice] = @photo_albums.errors.full_messages if @photo_albums.try(:errors)
            format.html { redirect_to(full_url('bookmark/manage')) }
        end
    end


    def delete
        Bookmarks.where(:id => params[:id]).delete_all

        respond_to do |format|
            format.html { redirect_to(full_url('bookmark/manage')) }
        end
    end
end
