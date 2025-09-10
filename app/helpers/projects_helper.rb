module ProjectsHelper
  # ---------- IMAGES ----------
  # 1re image (URL absolue ou asset)
  def project_image_src(project)
    raw = project.image_url.to_s
    return "" if raw.blank?

    first = raw.split(/[,;\n]/).map(&:strip).reject(&:blank?).first
    return first if first =~ /\Ahttps?:|^data:/
    asset_path(first)
  end

  # Liste d’images prêtes à l’affichage
  def project_image_list(project)
    raw = project.image_url.to_s
    return [] if raw.blank?

    raw.split(/[,;\n]/)
       .map(&:strip)
       .reject(&:blank?)
       .map { |p| p =~ /\Ahttps?:|^data:/ ? p : asset_path(p) }
  end

  # ---------- STATUT HÉBERGEMENT ----------
  def project_status(project)
    url = project.url.to_s.strip
    return [ "Non hébergé", "text-slate-900" ] if url.blank?

    # extrait un host propre (sans protocole, sans /path, sans www.)
    host = url.sub(/\Ahttps?:\/\//, "").sub(/\Awww\./, "").sub(/\/.*$/, "")
    [ "En ligne (#{host})", "text-emerald-600" ]
  end

  # ---------- FONCTIONNALITÉS ----------
  def project_features(project)
    if project.respond_to?(:features) && project.features.present?
      list = project.features.to_s.split(/\r?\n|,|;|•/).map(&:strip).reject(&:blank?)
      return list if list.any?
    end

    slug  = project.slug.to_s.downcase
    title = project.title.to_s.downcase

    map = {
      # Comédien (Lorenzo)
      "portfolio-comedien" => [
        "Galerie photo responsive (grille + slider)",
        "Lecteur vidéo avec navigation",
        "Formulaire de contact + validations",
        "SEO de base (métadonnées, OpenGraph, JSON-LD)"
      ],
      "lorenzo-granjon" => [
        "Galerie photo responsive (grille + slider)",
        "Lecteur vidéo avec navigation",
        "Formulaire de contact + validations",
        "SEO de base (métadonnées, OpenGraph, JSON-LD)"
      ],
      "site-lorenzo" => [
        "Galerie photo responsive (grille + slider)",
        "Lecteur vidéo avec navigation",
        "Formulaire de contact + validations",
        "SEO de base (métadonnées, OpenGraph, JSON-LD)"
      ],

      # Site psy
      "site-psy" => [
        "Pages services + parcours",
        "Informations pratiques & contact",
        "Prise de rendez-vous / formulaire",
        "SEO local & accessibilité"
      ],

      # Logos brasserie
      "brasserie-chez-nino" => [
        "Création de logo vectoriel (SVG)",
        "Palette colorimétrique & typographies",
        "Déclinaisons (clair/sombre, icône seule)",
        "Exports multi-formats (SVG, PDF, PNG, WebP)"
      ],
      "logo-chez-nino" => [
        "Création de logo vectoriel (SVG)",
        "Palette colorimétrique & typographies",
        "Déclinaisons (clair/sombre, icône seule)",
        "Exports multi-formats (SVG, PDF, PNG, WebP)"
      ],
      "chez-nino-logo" => [
        "Création de logo vectoriel (SVG)",
        "Palette colorimétrique & typographies",
        "Déclinaisons (clair/sombre, icône seule)",
        "Exports multi-formats (SVG, PDF, PNG, WebP)"
      ],

      # Tripmates
      "tripmates" => [
        "Sondages (dates, destination, budget, hébergements)",
        "Organisation & récap du voyage",
        "Gestion des participants",
        "UI rétro colorée & responsive"
      ]
    }

    return map[slug] if map.key?(slug)

    # Heuristique branding (logo)
    if title.include?("logo") || slug.include?("logo") || title.include?("branding")
      return [
        "Création de logo vectoriel (SVG)",
        "Palette colorimétrique & typographies",
        "Déclinaisons (clair/sombre, icône seule)",
        "Exports multi-formats (SVG, PDF, PNG, WebP)"
      ]
    end

    # Fallback web
    [
      "Pages responsive",
      "Formulaire de contact",
      "SEO de base (OpenGraph, JSON-LD)",
      "Performance (lazy-load, images optimisées)"
    ]
  end

  # ---------- COULEURS THÈME ----------
  def project_theme_colors(project)
    if project.respond_to?(:theme_colors) && project.theme_colors.present?
      cols = project.theme_colors.to_s.split(",").map(&:strip).reject(&:blank?)
      return normalize_colors(cols)
    end

    slug  = project.slug.to_s.downcase
    title = project.title.to_s.downcase

    map = {
      # Lorenzo : violets
      "portfolio-comedien" => %w[#6d28d9 #9333ea #c084fc],
      "lorenzo-granjon"    => %w[#6d28d9 #9333ea #c084fc],
      "site-lorenzo"       => %w[#6d28d9 #9333ea #c084fc],

      # Brasserie : verts profonds
      "brasserie-chez-nino" => %w[#2f6d51 #3ea76a #9ae6b4],
      "logo-chez-nino"      => %w[#2f6d51 #3ea76a #9ae6b4],
      "chez-nino-logo"      => %w[#2f6d51 #3ea76a #9ae6b4],

      # Psy : verts doux
      "site-psy"            => %w[#1b7f5f #34d399 #a7f3d0],

      # Tripmates : rétro (orange/teal/blue)
      "tripmates"           => %w[#e76f51 #2a9d8f #264653]
    }

    return normalize_colors(map[slug]) if map.key?(slug)

    # Heuristiques souples
    return %w[#2f6d51 #3ea76a #9ae6b4] if slug.include?("nino") || title.include?("nino")
    return %w[#1b7f5f #34d399 #a7f3d0] if slug.include?("psy")  || title.include?("psy")
    return %w[#e76f51 #2a9d8f #264653] if slug.include?("trip") || title.include?("tripmates")
    return %w[#2f6d51 #3ea76a #9ae6b4] if title.include?("logo") || slug.include?("logo")

    # Fallback
    %w[#0ea5e9 #6366f1 #a78bfa]
  end

  # ---------- DESCRIPTIONS ----------
  # Fallback “générique”
  def project_description_fallback(project)
    slug  = project.slug.to_s.downcase
    title = project.title.to_s.downcase

    return %(
      Site clair et rassurant pour présenter l’approche APsySE, le parcours,
      le cabinet et permettre un contact simple. Travail sur la lisibilité,
      la structure des contenus et la mise en valeur visuelle.
    ).strip if slug.include?("psy") || title.include?("psy")

    return %(
      Application de groupe pour organiser des sorties/voyages : création de
      sondages (budget, dates, destination, hébergements), discussion, récap
      et répartition. Rôle full-stack : modèles, vues, style et logique front.
    ).strip if slug.include?("trip") || title.include?("tripmates") || title.include?("voyage")

    return %(
      Quatre propositions de logo. Direction artistique moderne et adaptée
      aux supports web/impression. Fichiers fournis en SVG/PDF/PNG (clair/sombre).
    ).strip if slug.include?("nino") || title.include?("logo") || title.include?("branding")

    %(
      Présentation du projet, objectifs, choix techniques et points forts UX/UI.
      Priorité à la performance et au SEO de base.
    ).strip
  end

  # Chaîne finale utilisée dans la vue
  def project_description_text(project)
    slug = project.slug.to_s.downcase

    hardcoded = {
      "tripmates" => %(
        Application de groupe pour organiser des sorties/voyages : création de
        sondages (budget, dates, destination, hébergements), discussion, récap
        et répartition. Rôle full-stack : modèles, vues, style et logique front.
      ).strip,
      "site-psy" => %(
        Site clair et rassurant pour présenter l’approche APsySE, le parcours,
        le cabinet et permettre un contact simple. Travail sur la lisibilité,
        la structure des contenus et la mise en valeur visuelle.
      ).strip
    }

    # 1) si DB vide et description “officielle” existe, on l’utilise
    return hardcoded[slug] if project.description.to_s.strip.blank? && hardcoded.key?(slug)

    # 2) sinon ce qui est en base
    desc = project.description.to_s.strip
    return desc if desc.present?

    # 3) sinon fallback heuristique
    project_description_fallback(project)
  end

  private

  def normalize_colors(cols)
    arr = cols.first(3)
    arr << arr.last while arr.size < 3
    arr
  end
end
