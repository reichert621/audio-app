Rails.application.routes.draw do
  root 'application#index'

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
