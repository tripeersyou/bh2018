Rails.application.routes.draw do

  # Communities
  devise_for :suppliers
  devise_scope :supplier do
    authenticated :supplier do
      root 'postings#index', as: :supplier_root
      resources :postings do
        resources :reserve_postings, only [] do
          resources 'approve', to: 'reserve_postings#approve'
        end
      end
    end
  end

  # Companies
  devise_for :sellers
  devise_scope :seller do
    authenticated :seller do
        root 'products#index', as: :seller_root
        resources :products
        resources :postings, only: [:index, :show] do
          collection do
            post 'reserve', to: 'postings#reserve'
          end
        end
    end
  end

  # Customers of Recyclable Products
  devise_for :buyers
  devise_scope :buyer do
    authenticated :buyer do
      resources :orders, only: [:index, :show]
      root 'sellers#index', as: :buyer_root
      resources :sellers, only: [:show, :index] do
        resources :orders, only: [:new , :create]
      end
    end
  end
  
  root 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
