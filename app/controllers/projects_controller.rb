# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def index
    @projects = Project.where(published: true).order(:position)
    if params[:tech].present?
      term = ActiveRecord::Base.sanitize_sql_like(params[:tech].to_s.strip)
      @projects = @projects.where("techs ILIKE ?", "%#{term}%")
    end
  end

  def show
    @project = Project.find_by!(slug: params[:slug])
  end
end
