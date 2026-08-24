Rails.application.routes.draw do
  root "home#index"

  resources :snippets, only: [:new, :create, :show], param: :short_code do
    member do
      get :raw
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
