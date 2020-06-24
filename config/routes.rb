Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :products, only: [] do
    collection do
      post 'transfer', to: :transfer
      post 'buy', to: :buy
    end
  end
end
