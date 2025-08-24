# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Project.destroy_all

projects = [
  {
    title: "Cabinet de psychothérapie — site vitrine",
    subtitle: "Présentation du cabinet, approche APsySE, prise de contact",
    description: "Site clair et rassurant pour présenter l’approche APsySE, le parcours, le cabinet et permettre un contact simple. Travail sur la lisibilité, la structure des contenus et la mise en valeur visuelle.",
    techs: techs: "Rails,ERB,Tailwind,JS"
    # image locale (capture d’écran) -> voir section 'Images' ci-dessous
    image_url: "projects/psy-home.jpg",
    url: "https://frederiquegranjon.com/",
    github_url: nil,
    slug: "psy-apsyse",
    position: 1,
    published: true
  },
  {
    title: "Comédien — site portfolio",
    subtitle: "Parcours, photos, vidéos, contact",
    description: "Site de présentation d’un comédien : bio, CV artistique, galerie photo multi-lignes, slider vidéo et formulaire de contact. Design sobre et focus sur l’image.",
    techs: "Rails,ERB,Tailwind,JS",
    # pour l’instant non hébergé
    image_url: "projects/lorenzo-portfolio.jpg",
    url: nil, # => badge 'Non hébergé'
    github_url: nil, # si tu veux plus tard : lien GitHub
    slug: "portfolio-comedien",
    position: 2,
    published: true
  },
  {
    title: "Tripmates — application de voyages entre amis",
    subtitle: "Projet de formation (Le Wagon)",
    description: "Application de groupe pour organiser des sorties/voyages : création de sondages (budget, dates, destination, hébergements), discussion, récap, et répartition. Rôle full-stack : modèles, vues, style et logique front.",
    techs: "Rails,JS,HTML,CSS",
    image_url: "projects/tripmates.jpg",
    url: nil,            # si pas en ligne
    github_url: nil,     # mets le repo quand tu l’auras
    slug: "tripmates",
    position: 3,
    published: true
  }
]

Project.create!(projects)
puts "Seeds OK: #{Project.count} projets"
