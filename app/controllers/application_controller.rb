class ApplicationController < ActionController::Base
  before_action :force_html_format

  private

  def force_html_format
    # Forcer le HTML seulement si aucun format n’est précisé
    if params[:format].blank?
      request.format = :html
    end
  end
end
