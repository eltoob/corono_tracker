Rails.application.routes.draw do
  
  root 'home#index'
  get 'api/stats', to: 'home#stats'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
