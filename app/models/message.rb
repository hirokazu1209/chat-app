class Message < ApplicationRecord
  # 1つのメッセージは、1つのチャットルームに存在
  belongs_to :room
  # 1つのメッセージは、1人のユーザーから送信
  belongs_to :user
end
