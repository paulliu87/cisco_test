Rails.application.routes.draw do
  get 'home/index'
  get 'home/contact'

  root 'home#index'

  resources :lunchorders do
  	get 'placeorder'
  end

  resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
