# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#         api_users_signout GET    /users/signout(.:format)                                                                 api/v1/sessions#destroy {:format=>:json}
#          api_users_signin POST   /users/signin(.:format)                                                                  api/v1/sessions#create {:format=>:json}
#          api_users_signup POST   /users/signup(.:format)                                                                  api/v1/users#create {:format=>:json}
#                 api_users GET    /users(.:format)                                                                         api/v1/users#index {:format=>:json}
#                  api_user GET    /users/:id(.:format)                                                                     api/v1/users#show {:format=>:json}
#            api_list_cards GET    /lists/:list_id/cards(.:format)                                                          api/v1/cards#index {:format=>:json}
#                           POST   /lists/:list_id/cards(.:format)                                                          api/v1/cards#create {:format=>:json}
#             api_list_card GET    /lists/:list_id/cards/:id(.:format)                                                      api/v1/cards#show {:format=>:json}
#                           PATCH  /lists/:list_id/cards/:id(.:format)                                                      api/v1/cards#update {:format=>:json}
#                           PUT    /lists/:list_id/cards/:id(.:format)                                                      api/v1/cards#update {:format=>:json}
#                           DELETE /lists/:list_id/cards/:id(.:format)                                                      api/v1/cards#destroy {:format=>:json}
#    assign_member_api_list POST   /lists/:id/assign_member(.:format)                                                       api/v1/lists#assign_member {:format=>:json}
#  unassign_member_api_list POST   /lists/:id/unassign_member(.:format)                                                     api/v1/lists#unassign_member {:format=>:json}
#                 api_lists GET    /lists(.:format)                                                                         api/v1/lists#index {:format=>:json}
#                           POST   /lists(.:format)                                                                         api/v1/lists#create {:format=>:json}
#                  api_list GET    /lists/:id(.:format)                                                                     api/v1/lists#show {:format=>:json}
#                           PATCH  /lists/:id(.:format)                                                                     api/v1/lists#update {:format=>:json}
#                           PUT    /lists/:id(.:format)                                                                     api/v1/lists#update {:format=>:json}
#                           DELETE /lists/:id(.:format)                                                                     api/v1/lists#destroy {:format=>:json}
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

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
        resources :cards
        member do
          post 'assign_member'
          post 'unassign_member'
        end
      end
    
      devise_for :users, only: []
    end
  end
end
