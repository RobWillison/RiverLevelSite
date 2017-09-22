Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'homepage/index'
  root 'homepage#index'

  resources :rivers

  get 'api/rivers', to: 'api/rivers#all'
  get 'api/rivers/search', to: 'api/rivers#search'

  get "api/rivers/autocomplete" => "api/rivers#autocomplete"

  get "admin" => "admin#index"

  get "admin/gatherers" => "gatherers#index"

  get "admin/gatherers/:id" => "gatherers#show"

  get "admin/forecast-actual-diff-tool" => "forecast_actual_diff_tool#index"
  get "admin/forecast-actual-diff-tool/:days" => "forecast_actual_diff_tool#show"

  get "admin/predict" => "predict#index"
  get "admin/predict/:id" => "predict#show"

end
