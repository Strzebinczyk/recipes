# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
['Prosty przepis', 'Ciasto', 'Jednogarnkowe', 'Obiad', 'Śniadanie', 'Lunch', 'Wegetariańskie', 'Wegańskie', 'Fit',
 'Z piekarnika', 'Bezglutenowe', 'Deser', 'Ciasteczka', 'Drożdżowe', 'Na imprezę']
  .each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

User.create(email: 'cakesbyjosh@gmail.com', password: 'zaq12wsx', username: 'Josh')
user1 = User.find_by(email: 'cakesbyjosh@gmail.com')
User.create(email: 'goodfood@gmail.com', password: 'zaq12wsx', username: 'Ania')
user2 = User.find_by(email: 'goodfood@gmail.com')

recipe1_params = { name: 'Biszkopt bezowy z galaretką i kremem mascarpone', 'tag_ids' => ['', '2', '7', '12'],
                   serving: '12' }

recipe1 = user1.recipes.build(recipe1_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Jajka').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier puder').id, quantity: '1 szklanka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier puder').id, quantity: '2 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka ziemniaczana').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mascarpone').id, quantity: '250g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 30').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Truskawki').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Galaretka').id, quantity: '2 opakowania' }]
  .each do |recipe_ingredient|
  recipe1.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Formę 25x30cm wyłóż papierem do pieczenia, piekarnik nagrzej do 180 stopni C, góra-dół' },
 { instructions: 'Żółtka jajek utrzyj ze połową szklanki cukru pudru aż się spienią' },
 { instructions: 'W innej misce ubij białka z drugą połową szklanki cukru pudru na sztywną pianę' },
 { instructions: 'Szpatułką połącz delikatnie żółtka z białkami, tak aby zachować w masie jak najwięcej powietrza' },
 { instructions: 'Obie mąki partiami delikatnie wmieszaj do masy' },
 { instructions: 'Piecz przez około 30 minut aż wierzch ciasta będzie złoty i chrupiący' },
 { instructions: 'Pozwól biszkoptowi całkowicie się ostudzić' },
 { instructions: 'Rozmieszaj dwa opakowania galaretki w 800 ml gorącej wody i pozostaw do ostygnięcia' },
 { instructions: 'Mascarpone i śmietanę 30 prosto z lodówki przełóż do miski, dodaj 2 łyżki cukru pudru' },
 { instructions: 'Mascarpone ze śmietaną ubijaj mikserem tylko do momentu utworzenia się sztywnego kremu' },
 { instructions: 'Krem wyłóż na ciasto rozprowadzając go dokładnie po całej jego powierzchni' },
 { instructions: 'Na wierzch kremu wyłóż truskawki' },
 { instructions: 'Na wierzch ciasta wylej galaretkę, włóż ciasto do lodówki aż galaretka stężeje' }]
  .each do |step_instructions|
  recipe1.steps.build(step_instructions)
end

recipe1.image.attach(io: File.open(Rails.root.join('db/seed_images/biszkopt.jpg')),
                     filename: 'biszkopt.jpg')

recipe1.save

recipe2_params = { name: 'Chlebek bananowy', 'tag_ids' => ['', '2', '7', '12'],
                   serving: '6' }

recipe2 = user1.recipes.build(recipe2_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Banany').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier').id, quantity: '130g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '240g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '70g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Jajko').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Proszek do pieczenia').id, quantity: '1 łyżeczka' }]
  .each do |recipe_ingredient|
  recipe2.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Formę keksówkę wyłóż papierem do pieczenia, piekarnik nagrzej do 180 stopni C, góra-dół' },
 { instructions: 'Masło stop, banany rozgnieć widelcem na papkę' },
 { instructions: 'Do masy bananowej dodaj płynne masło i sypkie składniki, wymieszaj' },
 { instructions: 'Dodaj jajko, wymieszaj' },
 { instructions: 'Masę przełóż do formy i piecz przez około 50 minut' },
 { instructions: 'Piecz przez około 30 minut aż wierzch ciasta będzie złoty i chrupiący' }]
  .each do |step_instructions|
  recipe2.steps.build(step_instructions)
end

recipe2.image.attach(io: File.open(Rails.root.join('db/seed_images/chlebek_bananowy.jpg')),
                     filename: 'chlebek_bananowy.jpg')

recipe2.save

recipe3_params = { name: 'Kruche ciasteczka', 'tag_ids' => ['', '13', '7', '12'],
                   serving: '12' }

recipe3 = user1.recipes.build(recipe3_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Jajko').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier puder').id, quantity: '70g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Proszek do pieczenia').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '150g' }]
  .each do |recipe_ingredient|
  recipe3.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Wszystkie składniki zagnieć na jednolitą masę' },
 { instructions: 'Ciasto uformuj w kulę, owiń folią spożywczą i włóż do lodówki na co najmniej godzinę' },
 { instructions: 'Schłodzone ciasto rozwałkuj na grubość 0,5 cm' },
 { instructions: 'Wykrawaj dowolne kształty, układaj na wyłożonej papierem do pieczenia blasze' },
 { instructions: 'Piecz około 12 minut w piekarniku rozgrzanym do 180 stopni C, góra-dół' }]
  .each do |step_instructions|
  recipe3.steps.build(step_instructions)
end

recipe3.image.attach(io: File.open(Rails.root.join('db/seed_images/kruche_ciasteczka.jpg')),
                     filename: 'kruche_ciasteczka.jpg')

recipe3.save

recipe4_params = { name: 'Drożdżówka', 'tag_ids' => ['', '2', '7', '12', '14'],
                   serving: '12' }

recipe4 = user1.recipes.build(recipe4_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Żółtka').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier').id, quantity: '80g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '500g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '70g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Drożdże').id, quantity: '30g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mleko').id, quantity: '250ml' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Owoce').id, quantity: '500g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cytryna').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier puder').id, quantity: '120g' }]
  .each do |recipe_ingredient|
  recipe4.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Składniki powinny mieć temperaturę pokojową, jeśli trzeba wyjmij je wcześniej z lodówki' },
 { instructions: 'Mleko lekko podgrzej i rozpuść w nim drożdże' },
 { instructions: '500g mąki i 80g cukru wsyp do miski, wlej rozczyn z drożdży' },
 { instructions: 'Odczekaj 10 minut aż drożdże się spienią' },
 { instructions: 'Dodaj 100g masła i żółtka jaj, wyrabiaj ręką lub hakiem miksera na gładkie ciasto' },
 { instructions: 'Ciasto odstaw na 1-1,5 godziny do wyrastania' },
 { instructions: 'Formę 20 x 30cm wyłóż papierem do pieczenia, wyrośnięte ciasto przełóż do formy' },
 { instructions: 'Na ciasto wyłóż owoce i pozostaw do ponownego wyrastania na około 30 minut' },
 { instructions: 'W misce rozetrzyj na gładką masę 70g mąki, 50g masła i 50g cukru' },
 { instructions: 'Rozkrusz powstałą masę na powierzchni ciasta' },
 { instructions: 'Nagrzej piekarnik do 180 stopni C, grzałka góra-dół i piecz ciasto przez około 35 minut' },
 { instructions: 'Cukier puder wymieszaj z kilkoma łyżkami soku z cytryny' },
 { instructions: 'Powstałym lukrem polej ciasto po upieczeniu' }]
  .each do |step_instructions|
  recipe4.steps.build(step_instructions)
end

recipe4.image.attach(io: File.open(Rails.root.join('db/seed_images/drozdzowka.jpg')),
                     filename: 'drozdzowka.jpg')

recipe4.save

recipe5_params = { name: 'Placki z cukinią i porem', 'tag_ids' => ['', '6', '7'],
                   serving: '4' }

recipe5 = user2.recipes.build(recipe5_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Jajko').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '150g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Por').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukinia').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ziemniaki').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Koperek').id, quantity: '1 pęczek' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 18').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Olej').id, quantity: '6 łyżek' }]
  .each do |recipe_ingredient|
  recipe5.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Pora pokrój w półplasterki, cukinię i ziemniaki zetrzyj na tarce' },
 { instructions: 'Startą cukinię i ziemniaki zostaw przez 15 minut na sitku, żeby odsączyć wodę' },
 { instructions: 'Koperek posiekaj' },
 { instructions: 'Połącz koperek, warzywa, jajko i mąkę, dopraw solą i pieprzem' },
 { instructions: 'Powstałą masę smaż na patelni z olejem na złoto' },
 { instructions: 'Podawaj ze śmietaną' }]
  .each do |step_instructions|
  recipe5.steps.build(step_instructions)
end

recipe5.image.attach(io: File.open(Rails.root.join('db/seed_images/placki.jpg')),
                     filename: 'placki.jpg')

recipe5.save

recipe6_params = { name: 'Makaron dyniowy z soczewicą', 'tag_ids' => ['', '4', '6', '7', '8'],
                   serving: '4' }

recipe6 = user2.recipes.build(recipe6_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Dynia').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Makaron').id, quantity: '250g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Marchew').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czerwona soczewica').id, quantity: '4 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sos sojowy').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Kurkuma').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '2 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oliwa z oliwek').id, quantity: '2 łyżki' }]
  .each do |recipe_ingredient|
  recipe6.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Marchew pokrój w półplasterki, cebulę i dynię w kostkę' },
 { instructions: 'Marchew i cebulę podsmażaj przez chwilę na patelni z oliwą' },
 { instructions: 'Dodaj dynię i soczewicę, zalej szklanką wody i duś do miękkości' },
 { instructions: 'Makaron ugotuj' },
 { instructions: 'Do warzyw dodaj przyprawy, dwie łyżki wody z makaronu i czosnek' },
 { instructions: 'Zmiksuj sos na gładką konsystencję' },
 { instructions: 'Podawaj z makaronem' }]
  .each do |step_instructions|
  recipe6.steps.build(step_instructions)
end

recipe6.image.attach(io: File.open(Rails.root.join('db/seed_images/dyniowy_makaron.jpg')),
                     filename: 'dyniowy_makaron.jpg')

recipe6.save

recipe7_params = { name: 'Pieczona polędwiczka z jabłkami', 'tag_ids' => ['', '4', '10', '11'],
                   serving: '4' }

recipe7 = user2.recipes.build(recipe7_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Polędwica wieprzowa').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Jabłka').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czerwona cebula').id, quantity: '2' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ziemniaki').id, quantity: '8' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sałata').id, quantity: '3 garście' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oliwa z oliwek').id, quantity: '3 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sok z cytryny').id, quantity: '3 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Olej').id, quantity: '6 łyżek' }]
  .each do |recipe_ingredient|
  recipe7.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Piekarnik rozgrzej do 180 stopni C' },
 { instructions: 'Warzywa i owoce umyj, cebulę pokrój w piórka, jabłka w kawałki' },
 { instructions: 'Polędwiczkę dopraw pieprzem i solą, obsmaż na patelni z 3 łyżkami oleju rzepakowego' },
 { instructions: 'Dodaj cebulę i jabłka, smaż jeszcze przez chwilę' },
 { instructions: 'Ziemniaki pokrój w łódeczki, dopraw solą i pieprzem, posmaruj resztą oleju rzepakowego' },
 { instructions: 'Ziemniaki i polędwicę z jabłkami i cebulką wyłóż na blaszkę i piecz przez 30-45 minut' },
 { instructions: 'Sałatę skrop oliwą z oliwek i sokiem z cytryny, wymieszaj' }]
  .each do |step_instructions|
  recipe7.steps.build(step_instructions)
end

recipe7.image.attach(io: File.open(Rails.root.join('db/seed_images/poledwica_jablko.jpg')),
                     filename: 'poledwica_jablko.jpg')

recipe7.save

recipe8_params = { name: 'Makaron orzo z ciecierzycą', 'tag_ids' => ['', '4', '3', '7'],
                   serving: '4' }

recipe8 = user2.recipes.build(recipe8_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Ugotowana ciecierzyca').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '2 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czerwona cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Makaron orzo').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukinia').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Suszone pomidory').id, quantity: '4 kawałki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Koncentrat pomidorowy').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Bulion').id, quantity: '350ml' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Szpinak').id, quantity: '1 garść' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 30').id, quantity: '4 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Parmezan').id, quantity: '1 garść, tarty' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Słodka papryka').id, quantity: '1/2 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pieprz cayenne').id, quantity: '1/4 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Tymianek').id, quantity: '1/2 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'oregano').id, quantity: '1/2 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe8.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Cebulę pokrój w kostke i podsmaż razem z ciecierzycą na oliwie w garnku' },
 { instructions: 'Dodaj przeciśnięty przez praskę czosnek, suchy makaron i przyprawy, wymieszaj' },
 { instructions: 'Dodaj pokrojoną w kostkę cukinię, pokrojone drobno suszone pomidory i przecier pomidorowy' },
 { instructions: 'Wymieszaj i smaż przez 2 minuty' },
 { instructions: 'Wlej bulion i zagotuj, gotuj bez przykrycia około 15 minut od czasu do czasu mieszając' },
 { instructions: 'Dodaj szpinak i śmietankę, wymieszaj, zagotuj' },
 { instructions: 'Podawaj z tartym parmezanem' }]
  .each do |step_instructions|
  recipe8.steps.build(step_instructions)
end

recipe8.image.attach(io: File.open(Rails.root.join('db/seed_images/orzo.jpg')),
                     filename: 'orzo.jpg')

recipe8.save

recipe9_params = { name: 'Dutch baby', 'tag_ids' => ['', '5', '10', '7'],
                   serving: '4' }

recipe9 = user2.recipes.build(recipe9_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Jajka').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mleko').id, quantity: '125ml' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '80g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier wanilinowy').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier puder').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Jabłko').id, quantity: '1' }]
  .each do |recipe_ingredient|
  recipe9.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Włóż do piekarnika naczynie żaroodporne i nagrzej go do 220 stopni C' },
 { instructions: 'Jajka, mleko, mąkę i cukier wanilinowy zmiksuj razem' },
 { instructions: 'Jabłko obierz i pokrój na kawałki' },
 { instructions: 'Wysuń naczynie żaroodporne z piekarnika, dodaj do niego masło i wlej zmiksowane ciasto' },
 { instructions: 'Na ciasto wyłóż kawałki jabłka' },
 { instructions: 'Piecz przez 15-20 minut' },
 { instructions: 'Przed podaniem posyp cukrem pudrem' }]
  .each do |step_instructions|
  recipe9.steps.build(step_instructions)
end

recipe9.image.attach(io: File.open(Rails.root.join('db/seed_images/dutch_baby.jpg')),
                     filename: 'dutch_baby.jpg')

recipe9.save

recipe10_params = { name: 'Zupa z dyni', 'tag_ids' => ['', '4', '1', '7', '9'],
                    serving: '6' }

recipe10 = user2.recipes.build(recipe10_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Dynia').id, quantity: '800g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ziemniaki').id, quantity: '250g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '25g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '2 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Kurkuma').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Imbir świeży').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Bulion').id, quantity: '400ml' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 30').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe10.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Dynię obierz ze skórki, usuń nasiona i pokrój w kostkę, ziemniaki obierz i pokrój w kostkę' },
 { instructions: 'Cebulę pokrój w kostkę i podsmaż w garnku na maśle' },
 { instructions: 'Dodaj pokrojony w plasterki czosnek, dynię, ziemniaki, przyprawy i imbir' },
 { instructions: 'Wymieszaj i smaż przez 5 minut' },
 { instructions: 'Wlej bulion i zagotuj, gotuj bez przykrycia około 15 minut od czasu do czasu mieszając' },
 { instructions: 'Zmiksuj blenderem z dodatkiem śmietanki' }]
  .each do |step_instructions|
  recipe10.steps.build(step_instructions)
end

recipe10.image.attach(io: File.open(Rails.root.join('db/seed_images/zupa_dyniowa.jpg')),
                      filename: 'zupa_dyniowa.jpg')

recipe10.save

recipe11_params = { name: 'Bułeczki drożdżowe z masełkami', 'tag_ids' => ['', '10', '7', '14', '15'],
                    serving: '6' }

recipe11 = user2.recipes.build(recipe11_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Mąka przenna').id, quantity: '350g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Drożdże').id, quantity: '25g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukier').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól').id, quantity: 'do smaku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mleko').id, quantity: '170ml' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Jajko').id, quantity: '2' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Masło').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Natka pietruszki').id, quantity: '1 pęczek' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Musztarda dijon').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '2 ząbki' }]
  .each do |recipe_ingredient|
  recipe11.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Mleko lekko podgrzej i rozpusć w nim drożdże' },
 { instructions: 'Do miski wsyp mąkę, cukier i sól, wymieszaj i zrób w mące dołek' },
 { instructions: 'Wlej mleko z drożdżami i zaczekaj aż się spieni' },
 { instructions: 'Dodaj 50g masła i 1 jajko, wyrabiaj ciasto, aż będzie gładkie i jednolite' },
 { instructions: 'Odstaw do wyrastania na 1 godzinę' },
 { instructions: '300g masła podziel na 3 części' },
 { instructions: 'Do pierwszej dodaj posiekaną pietruszkę i soli do smaku, wymieszaj' },
 { instructions: 'Do drugiej dodaj przeciśnięty przez praskę czosnek i sól do smaku, wymieszaj' },
 { instructions: 'Do trzeciej dodaj musztardę, wymieszaj' },
 { instructions: 'Masełka odłóż do lodówki' },
 { instructions: 'Wyrośnięte ciasto formuj w kuleczki o wadze około 20g i układaj na blaszce w koło' },
 { instructions: 'Odstaw do wyrośnięcia na 20 minut' },
 { instructions: 'Piekarnik nagrzej do 180 stopni C, ciasto delikatnie posmaruj roztrzepanym jajkiem' },
 { instructions: 'Piecz przez około 25 minut na złoty kolor' },
 { instructions: 'Podawaj z masełkami' }]
  .each do |step_instructions|
  recipe11.steps.build(step_instructions)
end

recipe11.image.attach(io: File.open(Rails.root.join('db/seed_images/buleczki_z_maselkami.jpg')),
                      filename: 'buleczki_z_maselkami.jpg')

recipe11.save

recipe12_params = { name: 'Zapiekanka z kalafiorem i marchewką', 'tag_ids' => ['', '4', '7', '10'],
                    serving: '4' }

recipe12 = user2.recipes.build(recipe12_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Makaron').id, quantity: '150g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Kalafior').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Marchew').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 30').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Mąka pszenna').id, quantity: '2 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Musztarda').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Parmezan').id, quantity: '50g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Natka pietruszki').id, quantity: '1 pęczek' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Nasiona słonecznika').id, quantity: '20g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe12.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Piekarnik rozgrzej do 200 stopni C' },
 { instructions: 'Warzywa umyj, kalafiora podziel na różyczki a marchew zetrzyj' },
 { instructions: 'Makaron ugotuj, na 3 minuty przed końcem gotowania wrzuć do niego kalafiora' },
 { instructions: 'Śmietanę wymieszaj z mąką, musztardą i przyprawami a ser zetrzyj' },
 { instructions: 'Makaron z kalafiorem, marchewka i śmietaną przełóż do naczynia żaroodpornego, wymieszaj' },
 { instructions: 'Posyp serem i piecz przez 10 minut' },
 { instructions: 'Podawaj posypane słonecznikiem i pietruszką' }]
  .each do |step_instructions|
  recipe12.steps.build(step_instructions)
end

recipe12.image.attach(io: File.open(Rails.root.join('db/seed_images/zapiekanka_z_kalafiorem.jpg')),
                      filename: 'zapiekanka_z_kalafiorem.jpg')

recipe12.save

recipe13_params = { name: 'Makaron primavera', 'tag_ids' => ['', '4', '6', '7', '9', '8'],
                    serving: '4' }

recipe13 = user2.recipes.build(recipe13_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Makaron').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Fasolka szparagowa').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Marchew').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukinia').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oliwa').id, quantity: '2 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '3 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pomidor').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oregano').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Szczypiorek').id, quantity: '1/2 pęczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Bazylia').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe13.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Makaron ugotuj al dente razem z fasolką szparagową' },
 { instructions: 'Marchewkę obierz i pokrój w cienkie wstążki (można obieraczką do warzyw)' },
 { instructions: 'Tak samo pokrój cukinię' },
 { instructions: 'Cebulę pokrój w kostkę i podsmaż na oliwie' },
 { instructions: 'Dodaj marchewkę i przeciśnięty przez praskę czosnek' },
 { instructions: 'Dodaj pomidora pokrojonego w kostkę, cukinię i przyprawy' },
 { instructions: 'Gotuj aż warzywa zmiękną' },
 { instructions: 'Wymieszaj z makaronem i fasolką szparagową' },
 { instructions: 'Dopraw do smaku solą i pieprzem' },
 { instructions: 'Podawaj posypany szczypiorkiem' }]
  .each do |step_instructions|
  recipe13.steps.build(step_instructions)
end

recipe13.image.attach(io: File.open(Rails.root.join('db/seed_images/makaron_primavera.jpg')),
                      filename: 'makaron_primavera.jpg')

recipe13.save

recipe14_params = { name: 'Leczo z ciecierzycą', 'tag_ids' => ['', '4', '1', '7', '3', '8'],
                    serving: '4' }

recipe14 = user2.recipes.build(recipe14_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Kasza gryczana').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pomidory').id, quantity: '2' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Papryki').id, quantity: '2' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pieczarki').id, quantity: '400g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukinia').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ciecierzyca').id, quantity: '1 puszka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '2 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Wędzona papryka').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Olej').id, quantity: '2 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe14.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Warzywa umyj i pokrój w kostkę' },
 { instructions: 'Kaszę ugotuj' },
 { instructions: 'Cebulę zeszklij w garnku na oleju' },
 { instructions: 'Dodaj pieczarki, paprykę, cukinię i ciecierzycę i duś przez chwilę' },
 { instructions: 'Dodaj pomidory, przeciśnięty przez praskę czosnek i wędzoną paprykę' },
 { instructions: 'Duś aż wszystkie warzywa będą miękkie, dopraw do smaku' }]
  .each do |step_instructions|
  recipe14.steps.build(step_instructions)
end

recipe14.image.attach(io: File.open(Rails.root.join('db/seed_images/leczo_ciecierzyca.jpg')),
                      filename: 'leczo_ciecierzyca.jpg')

recipe14.save

recipe15_params = { name: 'Pieczony łosoś z warzywami', 'tag_ids' => ['', '4', '6', '1', '10', '9'],
                    serving: '4' }

recipe15 = user2.recipes.build(recipe15_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Łosoś').id, quantity: '600g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Brokuł').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Marchew').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cukinia').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oliwa').id, quantity: '2 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ziemniaki').id, quantity: '300g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '4 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe15.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Piekarnik nagrzej do 180 stopni C' },
 { instructions: 'Warzywa umyj, brokuł rozdziel na różyczki i podgotuj przez 4 minuty' },
 { instructions: 'Cukinię pokrój w grube plastry' },
 { instructions: 'Ziemniaki pokrój na frytki, dopraw solą i pieprzem i posmaruj oliwą' },
 { instructions: 'Rybę i warzywa wyłóż na blaszkę wyłożoną papierem do pieczenia' },
 { instructions: 'Czosnek pokrój w plasterki i rozrzuć na rybie i warzywach' },
 { instructions: 'Dopraw solą i pieprzem' },
 { instructions: 'Piecz przez około 30 minut do miękkości' }]
  .each do |step_instructions|
  recipe15.steps.build(step_instructions)
end

recipe15.image.attach(io: File.open(Rails.root.join('db/seed_images/losos_z_warzywami.jpg')),
                      filename: 'losos_z_warzywami.jpg')

recipe15.save

recipe16_params = { name: 'Kurczak w sosie marchewkowym', 'tag_ids' => ['', '4', '11'],
                    serving: '4' }

recipe16 = user2.recipes.build(recipe16_params)

[{ ingredient_id: Ingredient.find_or_create_by(name: 'Pierś z kurczaka').id, quantity: '500g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Imbir świeży').id, quantity: '1 łyżka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Garam masala').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cytryna').id, quantity: '2 łyżki soku' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Oliwa z oliwek').id, quantity: '4 łyżki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Jogurt naturalny').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Czosnek').id, quantity: '3 ząbki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Marchew').id, quantity: '3' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Kurkuma').id, quantity: '1/2 łyżeczki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Curry').id, quantity: '1 łyżeczka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pietruszka').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Cebula').id, quantity: '1' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Orzechy nerkowca').id, quantity: '1 garść' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Pomidory w puszce').id, quantity: '1 puszka' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Śmietana 30').id, quantity: '200g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Bulion').id, quantity: '1/2 szklanki' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Ryż').id, quantity: '100g' },
 { ingredient_id: Ingredient.find_or_create_by(name: 'Sól i pieprz').id, quantity: 'do smaku' }]
  .each do |recipe_ingredient|
  recipe16.recipe_ingredients.build(recipe_ingredient)
end

[{ instructions: 'Kurczaka pokrój w kostkę' },
 { instructions: 'Wymieszaj z wyciśniętym czosnkiem, startym imbirem, garam masala, sokiem z cytryny i jogurtem' },
 { instructions: 'Zamarynuj w lodówce przez minimum 2 godziny' },
 { instructions: 'Cebulę pokrój w kostkę a pietruszkę i marchewkę w małe kawałki' },
 { instructions: 'Na oliwie podsmaż cebulę, pietruszkę i marchewkę, po kilku minutach dodaj orzechy nerkowca' },
 { instructions: 'Całość zalej pomidorami i bulionem, gotuj przez 10 minut' },
 { instructions: 'Dodaj śmietanę i resztę przypraw i zmiksuj na gładki sos' },
 { instructions: 'Ryż ugotuj' },
 { instructions: 'Kurczaka dopraw solą i pieprzem i obsmaż na patelni' },
 { instructions: 'Kurczaka zalej sosem i zagotuj' },
 { instructions: 'Podawaj z ryżem' }]
  .each do |step_instructions|
  recipe16.steps.build(step_instructions)
end

recipe16.image.attach(io: File.open(Rails.root.join('db/seed_images/kurczak_w_sosie_marchewkowym.jpeg')),
                      filename: 'kurczak_w_sosie_marchewkowym.jpeg')

recipe16.save
