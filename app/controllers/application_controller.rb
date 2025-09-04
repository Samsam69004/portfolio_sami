class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :force_html_format
  allow_browser versions: :modern

  private

  def force_html_format
    # Si aucun format demandé (vieux navigateurs), on sert du HTML
    request.format = :html if params[:format].blank?
  end
end
