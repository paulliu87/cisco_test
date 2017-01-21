require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do

	let(:demo_lunchorder) {LunchOrder.create!(:normal => 8, :vegetarian => 2)}
	let(:demo_restaurant) {Restaurant.create!(:normal => 10, :vegetarian => 2)}

	describe 'show' do

		it 'assigns the right restaurant' do
			get :show, params: {id: demo_restaurant.id}
			expect(assigns(:restaurant)).to eq(demo_restaurant)
		end

	end

	describe 'new' do
		it 'renders the restaurant form' do
			get :new
			expect(response).to render_template(:new)
		end
	end

	describe 'create' do
		context "when valid params are passed" do
			before(:each) do
				restaurant = Restaurant.new(:normal => 10)
				post :create, restaurant: restaurant.attributes.except("id")
			end
			it "responds with status code 302" do
				expect(response).to have_http_status(302)
			end

			it "redirects to the created restaurant show page" do
				expect(response).to redirect_to("/restaurants/#{Restaurant.last.id}")
			end

			it "creates a new restaurant" do
				expect {
					post :create, params: {restaurant: {normal: 10}}
				}.to change(Restaurant,:count).by(1)
			end
		end
	end
end
