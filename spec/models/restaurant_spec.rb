require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  	let(:restaurant) {Restaurant.new(
  		name: "Restaurant Test",
  		rating: 5
	)}

  describe "validations" do
    it "saves with valid information" do
    	restaurant[:normal] = 10
	    expect(restaurant.save).to be true
    end

    it "does not allow without name" do
      restaurant.name = nil
      expect(restaurant.save).to be false
    end

    it "does not allow without rating" do
      restaurant.rating = nil
      expect(restaurant.save).to be false
    end

    it 'does not allow without food' do
      restaurant[:normal] = 0
      restaurant.save
      expect(restaurant.save).to be false
    end

    it 'does not save with repeated name' do
    	Restaurant.create(name: "Restaurant Test", rating: 3, normal: 10)
    	expect(restaurant.save).to be false
    end

    it 'does not allow rating to be more than 5' do
    	restaurant[:rating] = 6
    	expect(restaurant.save).to be false
    end

    it 'does not allow rating to be less than 0' do
    	restaurant[:rating] = -1
    	expect(restaurant.save).to be false
    end
  end

  describe "at_least_one_meal" do
    let(:restaurant) { Restaurant.new( name: "Restaurant Test", rating: 5) }
    it "return false when there is no food" do
      expect(restaurant.at_least_one_meal).to eq(false)
    end
  end

  pending "associations" do
    let(:acceptor) { FactoryGirl.create(:student) }
    let(:initiator) { FactoryGirl.create(:student) }
    let(:timeslot) {
      timeslot = FactoryGirl.create(:timeslot)
      timeslot.update_attributes(acceptor: acceptor, initiator: initiator)
      timeslot
    }

    it "has many accepted timeslots" do
      expect(acceptor.accepted_timeslots).to include(timeslot)
    end
    it "has many initiated timeslots" do
      expect(initiator.initiated_timeslots).to include(timeslot)
    end
  end
end

