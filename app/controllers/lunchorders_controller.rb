class LunchordersController < ApplicationController
	def new
	end

	def create
		@lunchorder = Lunchorder.new(lunchorcher.params)

		@lunchorder.save
		redirect_to @lunchorder
	end

	private
		def lunchorder_params
			params.require(:lunchorder).permit(:normal, :vegetarian, :gluten_free, :nut_free, :fish_free)
		end

end
