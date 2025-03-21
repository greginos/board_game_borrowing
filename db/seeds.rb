# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def create_board_game(name, ean, image_link, min_players, max_players, minimum_age, length, description)
  BoardGame.create!(
    name: name,
    ean: ean,
    image_link: image_link,
    min_players: min_players,
    max_players: max_players,
    minimum_age: minimum_age,
    length: length,
    description: description
  )
end

popular_games_data = [
  {
    name: "Les Aventuriers du Rail",
    ean: "0824968812683",
    image_link: "https://www.philibertnet.com/fr/days-of-wonder/2799-aventuriers-du-rail-les-824968717813.html",
    min_players: 2,
    max_players: 5,
    minimum_age: 8,
    length: "30-60 min",
    description: "Les Aventuriers du Rail est un jeu de société où les joueurs collectent des cartes de différents types de wagons de train qui leur permettent d'emprunter des lignes de chemin de fer reliant des villes d'Amérique du Nord. Plus les itinéraires sont longs, plus ils rapportent de points. Des points supplémentaires sont attribués à ceux qui remplissent leurs cartes Destination en reliant les villes éloignées, et à celui qui construit le plus long chemin continu de wagons. Alors, montez à bord pour une aventure ferroviaire palpitante !"
  },
  {
    name: "Catan",
    ean: "0035552601015",
    image_link: "https://www.toysrus.com/products/settlers-of-catan-board-game-5th-edition-mfg3071",
    min_players: 3,
    max_players: 4,
    minimum_age: 10,
    length: "60-120 min",
    description: "Dans Catan (anciennement Les Colons de Catane), les joueurs tentent d'être la force dominante sur l'île de Catane en construisant des colonies, des villes et des routes. À chaque tour, des dés sont lancés pour déterminer quelles ressources l'île produit. Les joueurs collectent ces ressources (bois, brique, mouton, grain et minerai) pour construire leurs civilisations. Tous les joueurs ont accès à toutes les ressources à tout moment grâce au commerce. Les colonies les plus récentes et les routes les plus longues rapportent des points de victoire supplémentaires. Soyez le premier à atteindre dix points de victoire et vous gagnerez !"
  },
  {
    name: "7 Wonders",
    ean: "3760175516909",
    image_link: "https://www.amazon.com/Board-Games-SV01EN-7-Wonders/dp/B08F65MX4L",
    min_players: 2,
    max_players: 7,
    minimum_age: 10,
    length: "30 min",
    description: "Dans 7 Wonders, vous dirigez l'une des sept grandes cités du monde antique. Développez votre merveille, exploitez les ressources de vos terres, participez à des conflits militaires et développez vos routes commerciales. Faites preuve de leadership et construisez votre héritage à travers les âges !"
  },
  {
    name: "Azul",
    ean: "0824968982393",
    image_link: "https://www.amazon.com/Board-Game-Mosaic-Tile-Placement-Next-Move/dp/B077MZ2MPW",
    min_players: 2,
    max_players: 4,
    minimum_age: 8,
    length: "30-45 min",
    description: "Azul capture la belle esthétique de l'art maure dans un jeu de société contemporain. Les joueurs jouent le rôle d'artisans décorant les murs du Palais Royal d'Évora. En sélectionnant soigneusement la bonne quantité et le bon style de carreaux, les artisans les plus astucieux planifient à l'avance pour maximiser la beauté de leur travail (sans parler de leurs scores !) tout en s'assurant de ne pas gaspiller de fournitures en cours de route."
  },
  {
    name: "Codenames",
    ean: "0859415631102",
    image_link: "https://www.czechgames.com/games/codenames",
    min_players: 2,
    max_players: 8,
    minimum_age: 14,
    length: "15-30 min",
    description: "Deux équipes rivales s'affrontent pour voir qui peut contacter tous leurs agents en premier. Les maîtres-espions donnent des indices d'un mot qui peuvent désigner plusieurs mots sur le plateau. Leurs coéquipiers essaient de deviner les mots de la bonne couleur tout en évitant ceux qui appartiennent à l'équipe adverse. De plus, tout le monde veut éviter l'assassin !"
  },
  {
    name: "Splendor",
    ean: "3760175512826",
    image_link: "https://www.amazon.com/Space-Cowboys-Splendor-Board-Game/dp/B00IZEUFIA",
    min_players: 2,
    max_players: 4,
    minimum_age: 10,
    length: "30 min",
    description: "Splendor est un jeu de cartes et de développement rapide et élégant dans lequel 2 à 4 joueurs s'affrontent pour devenir le marchand le plus riche de la Renaissance. En utilisant des jetons représentant des pierres précieuses, les joueurs acquièrent des mines, des moyens de transport et des boutiques. Splendor est un jeu de stratégie et de tactique où les joueurs doivent saisir les opportunités et anticiper les actions de leurs adversaires."
  },
  {
    name: "Dixit",
    ean: "3558380068782",
    image_link: "https://www.amazon.com/Asmodee-DI01US-Dixit-Board-Game/dp/B001SN8F5M",
    min_players: 3,
    max_players: 8,
    minimum_age: 8,
    length: "30 min",
    description: "Dixit est un jeu d'association d'images créatif et simple, où votre imagination déverrouille l'histoire. Dans ce jeu primé, les joueurs utiliseront les belles illustrations sur les cartes pour tromper leurs adversaires et deviner quelle image correspond à l'histoire."
  },
  {
    name: "Kingdomino",
    ean: "3760175516916",
    image_link: "https://www.amazon.com/Blue-Orange-Games-Kingdomino/dp/B06WVFR5HZ",
    min_players: 2,
    max_players: 4,
    minimum_age: 8,
    length: "15-20 min",
    description: "Kingdomino est un jeu de société où vous utilisez des dominos pour construire votre royaume. Chaque tour, vous connectez un nouveau domino à votre royaume existant, en veillant à ce que les types de terrain correspondent. Le jeu se termine lorsque chaque joueur a construit un carré de 5x5. Les points sont attribués en fonction du nombre de tuiles connectées dans chaque terrain et du nombre de couronnes dans ces terrains."
  },
  {
    name: "Pandemic",
    ean: "0681702501019",
    image_link: "https://www.amazon.com/Z-Man-Games-ZM7101-Pandemic/dp/B000CQYA6M",
    min_players: 2,
    max_players: 4,
    minimum_age: 8,
    length: "45 min",
    description: "Dans Pandemic, plusieurs maladies se sont déclarées simultanément dans le monde ! En tant que membres d'une équipe d'élite de spécialistes des maladies, vous devez traiter les points chauds de la maladie tout en recherchant des remèdes. Vous devez travailler ensemble pour réussir. Le temps presse car des épidémies et des éclosions accélèrent la propagation des maladies. Si une ou plusieurs maladies se propagent au-delà de la récupération, vous perdrez tous. Si vous découvrez les quatre remèdes, vous gagnerez tous !"
  },
  {
    name: "Terraforming Mars",
    ean: "0653341865291",
    image_link: "https://www.amazon.com/Stronghold-Games-SG05800-Terraforming-Mars/dp/B01GS4GGLE",
    min_players: 1,
    max_players: 5,
    minimum_age: 12,
    length: "120 min",
    description: "Dans Terraforming Mars, vous dirigez une corporation et travaillez ensemble dans le processus de terraformation de la planète Mars. Gagnez des points de victoire en contribuant le plus à la terraformation, mais aussi en faisant progresser l'infrastructure humaine à travers le système solaire, et en faisant d'autres choses louables."
  },
  {
    name: "Gloomhaven",
    ean: "817532015934",
    image_link: "https://www.amazon.com/Cephalofair-Games-Gloomhaven-Board-Game/dp/B01GS4UA0K",
    min_players: 1,
    max_players: 4,
    minimum_age: 14,
    length: "60-120 min",
    description: "Gloomhaven est un jeu de combat tactique coopératif dans un monde fantastique unique et évolutif. Les joueurs assumeront le rôle d'un mercenaire errant avec ses propres compétences spéciales et ses propres raisons de voyager dans ce coin sombre du monde. Les joueurs doivent travailler ensemble par nécessité pour nettoyer les donjons menaçants et les ruines oubliées. Ce faisant, ils amélioreront leurs capacités avec de l'expérience et du butin, découvriront de nouveaux endroits à explorer et piller, et développeront une histoire en constante évolution alimentée par les décisions qu'ils prendront."
  },
  {
    name: "Brass: Birmingham",
    ean: "814832020274",
    image_link: "https://www.amazon.com/Roxley-Game-Laboratory-Brass-Birmingham/dp/B07XD5B8RQ",
    min_players: 2,
    max_players: 4,
    minimum_age: 14,
    length: "60-120 min",
    description: "Brass: Birmingham est un jeu de stratégie économique qui vous raconte l'histoire d'entrepreneurs concurrents à Birmingham pendant la révolution industrielle anglaise, entre les années 1770 et 1870. Comme dans son prédécesseur, Brass: Lancashire, vous développerez, construirez et entretiendrez des industries, des réseaux et des ports dans le but de gagner des points de victoire."
  },
  {
    name: "Wingspan",
    ean: "0658978251452",
    image_link: "https://www.amazon.com/Stonemaier-Games-Wingspan-Board-Game/dp/B071J684JR",
    min_players: 1,
    max_players: 5,
    minimum_age: 10,
    length: "40-70 min",
    description: "Wingspan est un jeu de stratégie compétitif de poids moyen, axé sur les oiseaux, pour 1 à 5 joueurs. Chaque oiseau que vous jouez prolonge une chaîne de puissantes combinaisons dans l'un de vos trois habitats. Votre objectif est de découvrir et d'attirer les meilleurs oiseaux dans votre réseau de réserves naturelles."
  },
  {
    name: "Ganz Schön Clever",
    ean: "4010168248065",
    image_link: "https://www.amazon.com/Schmidt-Spiele-51231-Ganz-sch%C3%B6n-Clever/dp/B01N7J2Z76",
    min_players: 1,
    max_players: 4,
    minimum_age: 10,
    length: "30 min",
    description: "Ganz Schön Clever est un jeu de dés où vous marquez des points en choisissant judicieusement les dés à utiliser. Chaque dé que vous choisissez déclenche une chaîne d'actions qui peuvent vous rapporter encore plus de points. Le jeu est rapide, facile à apprendre et très addictif."
  },
  {
    name: "Everdell",
    ean: "810037370013",
    image_link: "https://www.amazon.com/Starling-Games-Everdell-Board-Game/dp/B07C93P19T",
    min_players: 1,
    max_players: 4,
    minimum_age: 13,
    length: "40-80 min",
    description: "Dans Everdell, vous dirigez un groupe de créatures qui cherchent à établir de nouveaux territoires. Utilisez des travailleurs pour collecter des ressources, construire des bâtiments et recruter des créatures. Chaque carte dans votre ville rapporte des points à la fin de la partie. Planifiez soigneusement votre ville pour créer des combinaisons puissantes et marquer le plus de points."
  },
  {
    name: "Root",
    ean: "810037370051",
    image_link: "https://www.amazon.com/Leder-Games-Root-Board-Game/dp/B0752F5R2D",
    min_players: 2,
    max_players: 4,
    minimum_age: 10,
    length: "60-90 min",
    description: "Root est un jeu d'aventure et de guerre où 2 à 4 joueurs s'affrontent pour le contrôle d'une grande étendue sauvage. Chaque joueur incarne une faction différente, chacune avec ses propres forces et faiblesses. Utilisez des guerriers, des bâtiments et des cartes pour contrôler des territoires et vaincre vos ennemis. Root est un jeu de stratégie complexe et passionnant qui offre une grande rejouabilité."
  },
  {
    name: "Spirit Island",
    ean: "0658978221200",
    image_link: "https://www.amazon.com/Greater-Than-Games-Spirit-Island/dp/B01N00FP1P",
    min_players: 1,
    max_players: 4,
    minimum_age: 13,
    length: "90-120 min",
    description: "Dans Spirit Island, les joueurs incarnent des esprits de la nature qui défendent leur île contre les envahisseurs. Utilisez des pouvoirs uniques pour effrayer, détruire ou absorber les colons. Travaillez ensemble pour protéger votre île et repousser les envahisseurs avant qu'ils ne la détruisent."
  },
  {
    name: "Ark Nova",
    ean: "4010168258788",
    image_link: "https://www.amazon.com/Feuerland-Spiele-Ark-Nova/dp/B09KY13X4L",
    min_players: 1,
    max_players: 4,
    minimum_age: 14,
    length: "90-150 min",
    description: "Dans Ark Nova, vous planifierez et concevrez un zoo moderne géré scientifiquement. Avec un plan de construction ultime en tête, vous construirez des enclos, accueillerez des animaux et soutiendrez des projets de conservation dans le monde entier. Les spécialistes et les bâtiments uniques vous aideront à atteindre cet objectif."
  },
  {
    name: "Dune: Imperium",
    ean: "810037370204",
    image_link: "https://www.amazon.com/Dire-Wolf-Digital-Dune-Imperium/dp/B08XW6Y643",
    min_players: 1,
    max_players: 4,
    minimum_age: 14,
    length: "60-120 min",
    description: "Dune: Imperium mélange la construction de deck et le placement d'ouvriers pour créer un nouveau jeu de stratégie thématique profond. Dans Dune: Imperium, vous vous battez pour le contrôle d'Arrakis, une source précieuse de l'épice."
  }
]

popular_games_data.each do |game_data|
  create_board_game(
    game_data[:name],
    game_data[:ean],
    game_data[:image_link],
    game_data[:min_players],
    game_data[:max_players],
    game_data[:minimum_age],
    game_data[:length],
    game_data[:description]
  )
end
