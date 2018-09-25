require 'api_constraints'

Rails.application.routes.draw do
	namespace :api, defaults: { format: :json }, 
				path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      get 'users/signout' => 'sessions#destroy'
      post 'users/signin' => 'sessions#create'
      post 'users/signup' => 'users#create'
      resources :users, only: [:index, :show]

      resources :lists do 
        member do
          post 'assign_member'
          post 'unassign_member'
        end
      end
      
      devise_for :users, only: []
    end
  end
end
