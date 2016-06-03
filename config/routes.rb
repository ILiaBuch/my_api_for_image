Rails.application.routes.draw do
  resources :gallery
  resources :users
  get '*unmatched_route', to: 'application#raise_not_found'
end
