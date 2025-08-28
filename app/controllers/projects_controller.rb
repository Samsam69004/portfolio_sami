# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :load_projects, only: :index
  before_action :load_project,  only: :show

  # GET /
  # (ta home = index des projets)
  def index
    # SEO
    @page_title       = "Portfolio — Sami Chabane, développeur web (Rails, Front-end)"
    @page_description = "Développeur web junior à Lyon : sites vitrines et apps Ruby on Rails, HTML, CSS, JavaScript. Projets récents, contact rapide."
    @og_image         = "og/default.jpg"
    @canonical_url    = root_url

    # HTTP cache (ETag + Last-Modified)
    lm          = @projects.maximum(:updated_at)
    tech_filter = params[:tech].presence # une simple string, pas un params slice
    fresh_when(etag: [ lm, tech_filter ], last_modified: lm, public: true)
  end

  # GET /projects/:slug
  def show
    # SEO
    @page_title       = "#{@project.title} — Portfolio Sami Chabane"
    @page_description = @project.subtitle.presence || @project.description.to_s.truncate(160)
    first_image       = @project.image_url.to_s.split(",").first&.strip
    @og_image         = first_image.presence || "og/default.jpg"
    @canonical_url    = project_url(@project)
    @meta_robots      = "noindex, nofollow" unless @project.published?

    # HTTP cache (ETag + Last-Modified) — ici pas de filtre, on se base sur le record
    lm = @project.updated_at
    fresh_when(etag: @project, last_modified: lm, public: true)
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end

  private

  def load_projects
    scope = Project.where(published: true).order(:position, created_at: :desc)

    # Filtre techno (multi-termes), compatible SQLite/Postgres et échappé
    if params[:tech].present?
      raw_terms = params[:tech].to_s.downcase.split(/[,\s]+/).reject(&:blank?)
      terms     = raw_terms.map { |t| ActiveRecord::Base.sanitize_sql_like(t) }
      terms.each do |t|
        scope = scope.where("LOWER(techs) LIKE ?", "%#{t}%")
      end
    end

    @projects = scope
  end

  def load_project
    @project = Project.find_by!(slug: params[:slug])
  end
end
