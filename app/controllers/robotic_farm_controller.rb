class RoboticFarmController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @rows = RoboticFarmMonitor.all
    end

    def import
        @row = RoboticFarmMonitor.new
        @row.group_id = params[:groupId]
        @row.seq = params[:seq]
        @row.air_hum = params[:airHum]
        @row.air_tmp = params[:airTmp]
        @row.soil_hum = params[:soilHum]
        @row.lux = params[:lux]

        respond_to do |format|
            if @row.save
                format.json { render :json => {result: 'success', group_id: params[:groupId], seq: params[:seq]}  }
            else
                format.json { render :json => {result: 'failed', group_id: params[:groupId], seq: params[:seq]}  }
            end
        end
    end

end
