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

	def placeorder
		@orderlist = place_order(params[:lunchorder_id])
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

	def place_order(id)
		restaurants_in_rating 
		lunchorder = LunchOrder.find(id)
		@orders_from_restaurants = call_restaurants(lunchorder,restaurants_in_rating)
	end

	def restaurants_in_rating #gives the high to low base on rating and not empty stock
		list_restaurants = Restaurant.order("rating DESC").to_a
		list_restaurants.reject do |restaurant|
				restaurant.normal == 0 &&
				restaurant.vegetarian == 0 &&
				restaurant.nut_free == 0 && 
				restaurant.gluten_free == 0 &&
				restaurant.fish_free == 0
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
				called_restaurants << order_from_a_restaurant(order,restaurant.id)
				order = advance_order(order, restaurant.id)
			end
		end
		called_restaurants
	end

	def order_is_empty(hash_of_meals)
		hash_of_meals[:normal] == 0 && 
		hash_of_meals[:vegetarian] == 0 && 
		hash_of_meals[:nut_free] == 0 &&
		hash_of_meals[:gluten_free] == 0 &&
		hash_of_meals[:fish_free] == 0
	end

	def order_from_a_restaurant(hash_of_meals, restaurant_id)
		hash_of_order = {}
		hash_of_meals.each do |key, value|
			if value != 0 && Restaurant.find(restaurant_id)[key] != 0
				hash_of_order[:name] = Restaurant.find(restaurant_id).name
				hash_of_order[:rating] = Restaurant.find(restaurant_id).rating
				if Restaurant.find(restaurant_id)[key] >= value
					hash_of_order[key] = value 
					Restaurant.find(restaurant_id)[key] = Restaurant.find(restaurant_id)[key] - value
				else
					hash_of_order[key] = Restaurant.find(restaurant_id)[key]
					Restaurant.find(restaurant_id)[key] = 0
				end
			end
		end
		hash_of_order
	end

	def advance_order(hash_of_meals, restaurant_id)
		updated_order = {}
		hash_of_meals.each do |key, value|
			if Restaurant.find(restaurant_id)[key] <= value 
				updated_order[key] = value - Restaurant.find(restaurant_id)[key]
			else
				updated_order[key] = 0 
			end
		end
		updated_order
	end
end
