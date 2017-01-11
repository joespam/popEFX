Rails.application.routes.draw do

	devise_for :users, controllers: { registrations: "users/registrations" }
	resources :pictures

	# custom routes for users
	get '/users/:id/' => 'users#show', :as => :user
	get '/users/' => 'users#show', :as => :all_users

	# custom route for landing page
	get '/home' => 'pictures#landing', :as => :home

	# root "pictures#index"
	root "pictures#landing"

end
