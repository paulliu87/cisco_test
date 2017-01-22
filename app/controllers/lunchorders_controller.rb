class LunchordersController < ApplicationController
	def show
		@lunchorder = LunchOrder.find(params[:id])
	end

	def new
	end

	def create
		convert_string_to_integer(lunchorder_params)
		@lunchorder = LunchOrder.new(convert_string_to_integer(lunchorder_params))
		@lunchorder.save
		redirect_to "/lunchorders/#{@lunchorder.id}"
	end

	def placeoreder
		@orderlist = place_order(params[:id])
	end



	private
	def lunchorder_params
		params.require(:lunchorder).permit( :normal, :vegetarian, :gluten_free, :nut_free, :fish_free)
	end

	def convert_string_to_integer(params)
		{
			:normal => params[:normal].to_i,
			:vegetarian => params[:vegetarian].to_i,
			:nut_free => params[:nut_free].to_i,
			:gluten_free => params[:gluten_free].to_i,
			:fish_free => params[:fish_free].to_i,
		}
	end

	def place_order
		restaurants_in_rating 
		lunchorder = LunchOrder.find(params[:id])
		@orders_from_restaurants = call_restaurants(lunchorder,restaurants_in_rating)
	end

	def restaurants_in_rating #gives the high to low base on rating and not empty stock
		list_restaurants = Restaurant.order("rating DESC").to_a
		list_restaurants.reject do |restaurant|
				restaurant.normal + restaurant.vegetarian + restaurant.nut_free + restaurant.gluten_free + restaurant.fish_free = 0
		end
	end

	def call_restaurants(lunchorder,array_of_restaurants)
		called_restaurants = []
		order = {
			:normal => lunchorder.normal,
			:vegetarian => lunchorder.vegetarian,
			:nut_free => lunchorder.nut_free,
			:gluten_free => lunchorder.gluten_free,
			:fish_free => lunchorder.fish_free,
		}

		array_of_restaurants.each do |restaurant|
			unless order_is_empty(order)
				called_restaurants << order_from_a_restaurant(order,restaurant)
				order = advance_order(order, restaurant)
			end
		end
		called_restaurants
	end

	def order_is_empty(hash_of_meals)
		hash_of_meals[:normal] == hash_of_meals[:vegetarian] == hash_of_meals[:nut_free] == hash_of_meals[:gluten_free] == hash_of_meals[:fish_free] == 0
	end

	def order_from_a_restaurant(hash_of_meals, restaurant)
		hash_of_order = {}
		hash_of_meals.each do |key, value|
			if value != 0 && restaurant.key != 0
				hash_of_order[:name] = restaurant.name
				hash_of_order[:rating] = restaurant.rating
				if restaurant.key >= value
					hash_of_order[:key] = value 
					restaurant.key = restaurant.key - value
				else
					hash_of_order[:key] = restaurant.key
					restaurant.key = 0
			end
		end
		hash_of_order
	end

	def advance_order(hash_of_meals, restaurant)
		hash_of_meals.map do |key, value|
			if restaurant.key <= value 
				:key => value - restaurant.key
			else
				:key => 0 
			end
		end
	end
end
