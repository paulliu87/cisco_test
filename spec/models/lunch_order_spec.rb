require 'rails_helper'

RSpec.describe LunchOrder, type: :model do
  	let(:lunchorder) {LunchOrder.new()}

  describe "validations" do
    it "saves with valid information" do
    	lunchorder[:normal] = 10
	    expect(lunchorder.save).to be true
    end

    it 'does not allow without food' do
      lunchorder[:normal] = 0
      lunchorder.save
      expect(lunchorder.save).to be false
    end

  end

  describe "at_least_one_meal" do
    let(:lunchorder) { LunchOrder.new() }
    it "return false when there is no food" do
      expect(lunchorder.at_least_one_meal).to eq(false)
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

