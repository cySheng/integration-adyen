Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlr
  #
  root 'checkouts#new'
  resources :checkouts, only: [:new, :create]
end
