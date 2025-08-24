module ApplicationHelper
  def project_image_src(project)
    url = project.image_url.to_s
    url.start_with?("http") ? url : asset_path(url)
  end

  def external_link_to(name, url, **opts)
    return "" if url.blank?
    link_to name, url, { target: "_blank", rel: "noopener noreferrer" }.merge(opts)
  end
end


