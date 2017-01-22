require 'rails_helper'

RSpec.describe LunchordersController, type: :controller do

	let(:demo_lunchorder) {LunchOrder.create!(:normal => 1, :vegetarian => 2)}

	describe 'show' do

		it 'assigns the right lunchorder' do
			get :show, params: {id: demo_lunchorder.id}
			expect(assigns(:lunchorder)).to eq(demo_lunchorder)
		end

	end

	describe 'new' do
		it 'renders the lunchorder form' do
			get :new
			expect(response).to render_template(:new)
		end
	end

	describe 'create' do
		context "when valid params are passed" do
			before(:each) do
				lunchorder = LunchOrder.new(:normal => 10)
				post :create, lunchorder: lunchorder.attributes.except("id")
			end
			it "responds with status code 302" do
				expect(response).to have_http_status(302)
			end

			it "redirects to the created lunchorder show page" do
				expect(response).to redirect_to("/lunchorders/#{LunchOrder.last.id}")
			end

			it "creates a new lunchorder" do
				expect {
					post :create, params: {lunchorder: {normal: 10}}
				}.to change(LunchOrder,:count).by(1)
			end
		end
	end

	describe 'placeorder' do
		context "when the restaurants have sufficient food, normal food only" do
			before(:each) do
				lunchorder = LunchOrder.new(:normal => 10)
				post :create, lunchorder: lunchorder.attributes.except("id")
			end

			it "renders the placeorder page" do
				get :placeorder
				expect(response).to render_template(:order)
			end
		end
	end

end
