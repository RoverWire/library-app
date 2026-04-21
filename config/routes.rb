# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  # get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker

  # Defines the root path route ('/')
  # root 'posts#index'

  # Devise resource_name changes to :api_v1_user
  # when using namespaced routes, so we need to use
  # scopes to work correctly.
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users,
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 },
                 controllers: {
                   sessions: 'api/v1/users/sessions',
                   registrations: 'api/v1/users/registrations'
                 }
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :users do
        resource :profile, only: %i[show update], controller: 'profile'
      end
    end
  end
end
