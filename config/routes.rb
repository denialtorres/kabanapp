Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "pages/home"
  get "pages/restricted"
  devise_for :users
  root "boards#index"

  resources :boards do
    # resources :columns do
    #   resources :cards do
    #     resource :move, only: :update, module: :cards
    #   end
    # end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # main kaban endpoints
  namespace :api do
    namespace :v1 do
      resources :boards do
        resources :cards, only: [ :create, :update ]
        post "cards/:id/assign", to: "cards#assign"
        post "cards/:id/unassign", to: "cards#unassign"
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
