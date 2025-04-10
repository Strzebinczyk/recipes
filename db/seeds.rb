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
Tag.create(name: 'Quick and easy')
Tag.create(name: 'Cake')
Tag.create(name: 'One pot')
Tag.create(name: 'Dinner')
Tag.create(name: 'Breakfast')
Tag.create(name: 'Lunch')
Tag.create(name: 'Vegetarian')
Tag.create(name: 'Vegan')
Tag.create(name: 'Fit')
Tag.create(name: 'Tray bake')
Tag.create(name: 'Gluten-free')
Tag.create(name: 'Dessert')
Tag.create(name: 'Cookies')
Tag.create(name: 'Muffins')
Tag.create(name: 'Party food')
