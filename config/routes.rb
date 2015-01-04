Rails.application.routes.draw do
  devise_for :users
  root 'application#index'

  devise_scope :user do
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end

  namespace :api do
    resources :texts do
      resources :chapters, only: :index
    end

    resources :chapters, only: :show do
      resources :excerpts, shallow: true
    end

    resources :excerpts, only: :show do
      resources :recordings, shallow: true
    end
  end
end
