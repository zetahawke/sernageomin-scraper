Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :entries, only: %i[index] do
    collection do
      post 'init_scrap', to: 'entries#init_scrap'
      get 'empty_records', to: 'entries#empty_records'
      get 'completed_records', to: 'entries#completed_records'
    end
  end
end
