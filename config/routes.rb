Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'homepage/index'
  root 'homepage#index'

  resources :rivers

  get 'api/rivers', to: 'api/rivers#all'

  get "api/rivers/autocomplete" => "api/rivers#autocomplete"

  get "admin" => "admin#index"

  get "admin/gatherers" => "gatherers#index"

  get "admin/gatherers/:id" => "gatherers#show"


end
