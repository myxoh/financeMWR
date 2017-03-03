Rails.application.routes.draw do

  get 'finance/lookup/:value' => 'finance#lookup'

  get 'finance/quote/:value' => 'finance#quote'

  get 'notifications'=>'notifications#index'

  post 'subscribe'=>'subscribe#create'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
