Rails.application.routes.draw do

	devise_for :users, controllers: { registrations: "users/registrations" }
	resources :pictures do
		member do
			put "like", to: "pictures#upvote"
		end
	end

	# custom routes for users
	get '/users/:id/' => 'users#show', :as => :user
	get '/users/' => 'users#index', :as => :all_users

	# custom route for landing page
	get '/home' => 'pictures#landing', :as => :home

	# custom bubble bar search route
	get '/bubbleBar', :to => 'pictures#bubbleBarSearch'

	# root "pictures#index"
	root "pictures#landing"

end
