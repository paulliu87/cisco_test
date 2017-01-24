class RestaurantsController < ApplicationController
	def index
		@restaurants = Restaurant.all
	 	if request.xhr?
     		render :layout => false
     	else
     		render "index"
     	end
	end

	def show
		@restaurant = Restaurant.find(params[:id])
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
		convert_string_to_integer(restaurant_params)
		@restaurant = Restaurant.new(convert_string_to_integer(restaurant_params))
		@restaurant.save
		
     	if request.xhr?
     		render :layout => false
     	else
			redirect_to "/restaurants/#{@restaurant.id}"
     	end
	end

	private
		def restaurant_params
			params.require(:restaurant).permit( :name, :rating, :normal, :vegetarian, :gluten_free, :nut_free, :fish_free)
		end

		def convert_string_to_integer(params)
			{
				:name => params[:name],
				:rating => params[:rating].to_i,
				:normal => params[:normal].to_i,
				:vegetarian => params[:vegetarian].to_i,
				:nut_free => params[:nut_free].to_i,
				:gluten_free => params[:gluten_free].to_i,
				:fish_free => params[:fish_free].to_i,
			}
		end
end
