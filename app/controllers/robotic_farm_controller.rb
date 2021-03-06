class RoboticFarmController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @group_ids = RoboticFarmMonitor.select(:group_id).distinct
        @group_id = if params[:group_id].nil? 
            @group_ids[0].group_id 
        else
            params[:group_id]
        end
        @rows = RoboticFarmMonitor.order('created_at DESC')
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
