class Message < ApplicationRecord
  # 1つのメッセージは、1つのチャットルームに存在
  belongs_to :room
  # 1つのメッセージは、1人のユーザーから送信
  belongs_to :user
  # 「content」カラムに、presence: trueを設けることで、空の場合はDBに保存しないというバリデーションを設定
  validates :content, presence: true
end
