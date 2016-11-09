Rails.application.routes.draw do

	devise_for :users, controllers: { registrations: "users/registrations" }
	resources :pictures
	root "pictures#index"

	# custom routes for users
	get '/users/:id/' => 'users#show', :as => :user
	get '/users/' => 'users#show', :as => :all_users
end
