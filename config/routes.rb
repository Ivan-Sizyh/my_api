Rails.application.routes.draw do
  resources :schools, only: [] do
    resources :classes, only: :index do
      resources :students, only: :index
    end
  end

  resources :students, only: %i[create destroy]
end
