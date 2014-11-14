class LoggerController < ApplicationController
	def index
		@histories = LoginHistory.all
	end
end
