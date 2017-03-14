class ResumeController < ApplicationController
    def index
        @resume = YAML.load_file('public/my_resume/resume.yaml')
        @lang = params[:lang]
        respond_to do |format|
            format.html { render :index, layout: false }
        end
    end
end
