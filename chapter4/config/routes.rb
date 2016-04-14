Rails.application.routes.draw do
  resources :tasks

  root to: 'welcome#index'
end
