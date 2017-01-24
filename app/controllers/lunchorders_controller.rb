class LunchordersController < ApplicationController
	def index
		@lunchorders = LunchOrder.all
     	if request.xhr?
     		render :layout => false
     	else
     		render "index"
     	end
	end
	
	def show
		@lunchorder = LunchOrder.find(params[:id])
		if request.xhr?
     		render :layout => false
     	else
     		render "show"
     	end
	end

	def new
	 	if request.xhr?
     		render :layout => false
     	else
     		render "new"
     	end
	end

	def create
		convert_string_to_integer(lunchorder_params)
		@lunchorder = LunchOrder.new(convert_string_to_integer(lunchorder_params))
		@lunchorder.save
     	if request.xhr?
     		render :layout => false
     	else
			redirect_to "/lunchorders/#{@lunchorder.id}"
     	end
	end

	def placeorder
		@orderlist = place_order(params[:lunchorder_id])
		p @orderlist
     	if request.xhr?
     		render :layout => false
     	else
     		render "placeorder"
     	end
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
		lunchorder = LunchOrder.find(id)
		restaurants_list = rang_fit_restaurants(lunchorder) 
		@orders_from_restaurants = filter_empty_slot(call_restaurants(lunchorder,restaurants_list))
	end

	def rang_fit_restaurants(lunchorder)
		restaurants = restaurants_in_rating
		restaurants = remove_empty_restaurants(restaurants)
		restaurants = provid_right_food(lunchorder,restaurants)
	end

	def provid_right_food(lunchorder,restaurants)
		restaurants_list = []
		five_to_one_star_restaurants = split_in_rating(restaurants)
		five_to_one_star_restaurants.each do |array_of_restaurants|
			restaurants_list << best_fit_food(array_of_restaurants,lunchorder)
		end
		p restaurants_list
		restaurants_list.flatten
	end

	def split_in_rating(restaurants)
		five_star_restaurants = []
		four_star_restaurants = []
		three_star_restaurants = []
		two_star_restaurants = []
		one_star_restaurants = []
		zero_star_restaurants = []
		restaurants_list = [five_star_restaurants,four_star_restaurants,three_star_restaurants,two_star_restaurants,one_star_restaurants,zero_star_restaurants]
		
		restaurants.each do |restaurant|
			restaurants_list[ 5 - restaurant.rating ] << restaurant
		end
		
		restaurants_list
	end

	def best_fit_food(array_of_restaurants,lunchorder)
		temp_array = []
		array_of_restaurants.each do |restaurant|
			score = 0
			score = score_restaurant(restaurant,lunchorder)
			temp_array << [score, restaurant]
		end
		restaurants_list = high_to_low_score(temp_array)
		restaurants_list = filter_integer(restaurants_list)
	end

	def score_restaurant(restaurant,lunchorder)
		score = 0
		[:normal,:vegetarian,:gluten_free,:nut_free,:fish_free].each do |key|
			if (lunchorder[key] > restaurant[key]) && (restaurant[key] != 0)
				score = score + 1
			elsif (lunchorder[key] < restaurant[key]) && (lunchorder[key] != 0)
				score = score + 2
			end
		end
		score
	end

	def high_to_low_score(array)
		array.sort_by { |a| a[0] }.reverse
	end

	def filter_integer(restaurants_list)
		restaurants_list.flatten.reject do |element|
			element.class == Integer
		end
	end

	def filter_empty_slot(restaurants_list)
		restaurants_list.reject do |element|
			element[:name] == nil
		end
	end

	def restaurants_in_rating #gives the high to low base on rating and not empty stock
		list_restaurants = Restaurant.order("rating DESC").to_a
	end

	def remove_empty_restaurants(restaurants)
		restaurants.reject do |restaurant|
			(restaurant.normal == 0 || restaurant.normal == nil )&&
			(restaurant.vegetarian == 0 || restaurant.vegetarian == nil )&&
			(restaurant.nut_free == 0 || restaurant.nut_free == nil )&& 
			(restaurant.gluten_free == 0 || restaurant.gluten_free == nil )&&
			(restaurant.fish_free == 0|| restaurant.fish_free == nil)
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
			p order
			p called_restaurants
			unless order_is_empty(order)
				p "@@@@@@@@@@@@@@"
				p restaurant.id
				called_restaurants << order_from_a_restaurant(order,restaurant.id)
				order = advance_order(order, called_restaurants.last)
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
			if value != 0  && (Restaurant.find(restaurant_id)[key] != 0)
				hash_of_order[:name] = Restaurant.find(restaurant_id).name
				hash_of_order[:rating] = Restaurant.find(restaurant_id).rating
				if Restaurant.find(restaurant_id)[key] >= value
					hash_of_order[key] = value 
					Restaurant.find(restaurant_id)[key] = Restaurant.find(restaurant_id)[key] - value
					# Restaurant.update(restaurant_id, key => (Restaurant.find(restaurant_id)[key] - value))
				else
					hash_of_order[key] = Restaurant.find(restaurant_id)[key]
					Restaurant.find(restaurant_id)[key] = 0
					# Restaurant.update(restaurant_id, key => 0)
				end
			else
				hash_of_order[key] = 0
			end
		end
		hash_of_order
	end

	def advance_order(hash_of_meals, changes)
		updated_order = {}
		hash_of_meals.each do |key, value|
			updated_order[key] = hash_of_meals[key] - changes[key]
		end
		updated_order
	end
end
