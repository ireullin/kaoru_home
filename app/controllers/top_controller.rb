class TopController < ApplicationController
  def index
  	@weather = Weather.all

  end
end
