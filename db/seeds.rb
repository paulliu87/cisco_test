# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


LunchOrder.create(
	:normal => 38,
	:vegetarian => 5,
	:nut_free => 0,
	:gluten_free => 7,
	:fish_free => 0,
)

Restaurant.create(
	:name => "Restauran A",
	:rating => 5,
	:normal => 36,
	:vegetarian => 4,
	:nut_free => 0,
	:gluten_free => 0,
	:fish_free => 0,
)

Restaurant.create(
	:name => "Restauran B",
	:rating => 3,
	:normal => 60,
	:vegetarian => 20,
	:nut_free => 0,
	:gluten_free => 20,
	:fish_free => 0,
)
Restaurant.create(
	:name => "Restauran C",
	:rating => 3,
	:normal => 0,
	:vegetarian => 0,
	:nut_free => 0,
	:gluten_free => 0,
	:fish_free => 0,
)