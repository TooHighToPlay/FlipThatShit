Spinthatshit::Application.routes.draw do
  root to: 'spins#index'
  resources :spins, only: [ :create, :update ]
  get '/:game_id' => 'spins#index'
end