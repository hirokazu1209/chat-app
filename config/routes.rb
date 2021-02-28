Rails.application.routes.draw do
  devise_for :users
  # ルートパスへのアクセスがあったら、messages_controllerのindexアクションが呼び出される
  root to: "rooms#index"
  # ユーザー編集画面の表示へアクセスするための記述
  resources :users, only: [:edit, :update]
  # 新規チャットルームの作成で動くアクションは「new」と「create」
  # チャットルームの削除機能「destroy」を実装
  resources :rooms, only: [:new, :create, :destroy] do
    # どのルームで投稿されたメッセージなのかをパスから判断できるようにしたいので、ルーティングのネストを利用
    # メッセージに結びつくルームのidの情報を含んだパスを、受け取れるようになる
    resources :messages, only: [:index, :create]
  end
end
