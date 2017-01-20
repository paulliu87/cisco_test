class LunchOrder < ApplicationRecord
	def change
		create_table 	:lunchorders do |t|
			t.integer 	:normal
			t.integer 	:vegetarian
			t.integer 	:nut_free
			t.integer 	:gluten_free
			t.integer 	:fish_free

			t.timestamps
		end
	end
end
