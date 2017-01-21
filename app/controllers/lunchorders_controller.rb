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
end
