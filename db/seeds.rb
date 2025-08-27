# db/seeds.rb
if Rails.env.test?
  puts "Skipping seeds in test environment"
  return
end
# Reset
Project.destroy_all

projects = [
  {
    title: "Cabinet de psychothérapie — site vitrine",
    subtitle: "Présentation du cabinet, approche APsySE, prise de contact",
    description: "Site clair et rassurant pour présenter l’approche APsySE, le parcours, le cabinet et permettre un contact simple. Travail sur la lisibilité, la structure des contenus et la mise en valeur visuelle.",
    techs: "Rails,ERB,Tailwind,JS",
    # image locale (capture d’écran)
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
    image_url: "projects/lorenzo-portfolio.jpg",
    url: nil,      # non hébergé pour l’instant
    github_url: nil,
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
    url: nil,
    github_url: nil,
    slug: "tripmates",
    position: 3,
    published: true
  },
  {
  title: "Création de logo pour la brasserie Chez Nino",
  subtitle: "Identité visuelle et branding",
  description: "Quatre propositions de logo, design moderne et adaptable.",
  techs: "Illustrator, Photoshop",
  image_url: "projects/chez-nino-logo1.jpg,projects/chez-nino-logo2.jpg,projects/chez-nino-logo3.jpg,projects/chez-nino-logo4.jpg",
  slug: "chez-nino-logo",
  published: true
  }
]

Project.create!(projects)
puts "Seeds OK: #{Project.count} projets"
