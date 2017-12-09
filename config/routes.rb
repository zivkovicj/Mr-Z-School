Rails.application.routes.draw do

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/partner', to: 'static_pages#partner'
  get   '/materials', to: 'static_pages#materials', :as => "materials"
  get    '/signup',  to: 'teachers#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :admins
  resources :account_activations, only: [:edit]
  resources :checkpoints
  resources :consultancies, only: [:new, :create, :show, :index, :destroy]
  resources :goal_students do
    get  'checkpoints', on: :member
    post 'update_checkpoints', on: :member
    get 'approve', on: :member
  end
  resources :labels
  resources :label_objectives do
    post 'update_quantities', on: :collection
  end
  resources :objective_seminars do
    post 'update_pretests', on: :collection
    post 'update_priorities', on: :collection
  end
  resources :objective_students
  resources :objectives do
    get 'quantities', on: :member
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :pictures
  resources :preconditions
  resources :questions do
    post 'details', on: :collection
    post 'create_group', on: :collection
  end
  resources :quizzes
  resources :ripostes
  resources :seminars do
    get 'pretests', on: :member
    get 'priorities', on: :member
    get 'scoresheet', on: :member
    get 'student_view', on: :member
    get 'benchmarks', on: :member
  end
  resources :seminar_students do
    get 'removeFromClass', on: :member
    post 'update_benchmarks', on: :member
  end
  resources :schools do
    get 'verify', on: :member
    post 'verify_update', on: :member
  end
  resources :students do
    get 'edit_teaching_requests', on: :member
  end
  resources :teachers 
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
