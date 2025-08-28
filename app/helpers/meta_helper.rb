# app/helpers/meta_helper.rb
module MetaHelper
  def meta_title
    (@page_title.presence || "Sami Chabane — Développeur web à Lyon").to_s
  end

  def meta_description
    base = @page_description.presence || "Développeur web (Ruby on Rails, HTML/CSS, JavaScript, Tailwind). Projets, contact."
    strip_tags(base).squish.truncate(160, separator: " ")
  end

  def meta_image
    candidate = @og_image.presence || "og/default.jpg"
    absolute_url_for_image(candidate)
  end

  def canonical_url
    return @canonical_url if @canonical_url.present?
    uri = URI.parse(request.original_url)
    uri.query = nil
    uri.fragment = nil
    uri.to_s
  end

  def meta_robots
    @meta_robots.presence || "index, follow"
  end

  private

  def absolute_url_for_image(path_or_url)
    return path_or_url if path_or_url.to_s =~ /\Ahttps?:\/\//i
    image_url(path_or_url) # URL absolue (ok OG/Twitter). Assure APP_HOST/asset_host en prod.
  end
end
