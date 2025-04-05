Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  authenticate :user, ->(user) { user.super_admin? } do
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    mount Sidekiq::Web => "/sidekiq"
    mount Fastentry::Engine, at: "/fastentry"
    resources :boards, only: [ :index, :show ]
  end

  get "pages/home"
  root "pages#home"

  devise_for :users


  get "up" => "rails/health#show", as: :rails_health_check

  # main kaban endpoints
  namespace :api do
    namespace :v1 do
       get "cards/my_cards", to: "cards#my_cards"
       get "repositories/summary", to: "repositories#summary"

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
