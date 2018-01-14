Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'homepage/index'
  root 'homepage#index'

  get 'account', to: 'users/account#show'
  post 'account', to: 'users/account#edit'

  resources :rivers do
    resources :history
  end

  get 'api/rivers', to: 'api/rivers#all'
  get 'api/rivers/search', to: 'api/rivers#search'

  get 'api/predictions', to: 'api/predictions#all'

  get "api/rivers/autocomplete" => "api/rivers#autocomplete"

  get "admin" => "admin#index"

  get "admin/jobs" => "job#index"
  post "admin/jobs" => "job#create"

  get "admin/gatherers" => "gatherers#index"

  get "admin/gatherers/:id" => "gatherers#show"

  get "admin/forecast-actual-diff-tool" => "forecast_actual_diff_tool#index"
  get "admin/forecast-actual-diff-tool/:days" => "forecast_actual_diff_tool#show"

  get "admin/predict" => "predict#index"
  get "admin/predict/:id" => "predict#show"

  get "admin/model_config" => "model_config#index"

  get "admin/acuracy" => "acuracy#index"

end
