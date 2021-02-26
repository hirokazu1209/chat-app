Rails.application.routes.draw do
  devise_for :users
  get 'messages/index'
  # ルートパスへのアクセスがあったら、messages_controllerのindexアクションが呼び出される
  root to: "messages#index"
  # ユーザー編集画面の表示へアクセスするための記述
  resources :users, only: [:edit, :update]
  # 新規チャットルームの作成で動くアクションは「new」と「create」
  resources :rooms, only: [:new, :create]
end
