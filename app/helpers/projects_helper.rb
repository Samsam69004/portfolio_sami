module ProjectsHelper
  def project_image_src(project)
    url = project.image_url.to_s.strip

    if url.blank?
      # fallback 16:9
      return "https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=1200&auto=format&fit=crop"
    end

    # URL externe (http/https) → on renvoie tel quel
    return url if url =~ /\Ahttps?:\/\//i

    # Chemin relatif vers app/assets/images → on passe par asset_path
    asset_path(url)
  end
end
