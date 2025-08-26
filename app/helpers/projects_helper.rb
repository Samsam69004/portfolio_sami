module ProjectsHelper
  # Renvoie une URL d'image "principale" (la 1re)
  def project_image_src(project)
    raw = project.image_url.to_s.strip
    return "" if raw.blank?

    first = raw.split(",").map(&:strip).reject(&:blank?).first
    return first if first =~ /\Ahttps?:|^data:/

    # chemin relatif => doit exister dans app/assets/images
    asset_path(first)
  end

  # Renvoie la liste des URLs prêtes à être affichées
  def project_image_list(project)
    raw = project.image_url.to_s
    return [] if raw.blank?

    raw.split(",")
       .map(&:strip)
       .reject(&:blank?)
       .map { |p| (p =~ /\Ahttps?:|^data:/) ? p : asset_path(p) }
  end
end
