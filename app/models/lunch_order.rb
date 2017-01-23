class LunchOrder < ApplicationRecord
	validate :at_least_one_meal
	after_initialize :init

	def init
		self.normal ||= 0
		self.vegetarian ||= 0
		self.nut_free ||= 0
		self.gluten_free ||= 0
		self.fish_free ||= 0
	end

	def at_least_one_meal
		if (self.normal + self.vegetarian + self.nut_free + self.gluten_free + self.fish_free) <= 0
			errors.add(:storage, "must have at least one meal.")
			false
		end
	end
end
