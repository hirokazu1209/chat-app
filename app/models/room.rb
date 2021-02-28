class Room < ApplicationRecord
  # Room（親モデル）が削除されたときに、関連付けしているRoomUser（子モデル）は削除
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  # 1つのチャットルームに、メッセージは複数存在
  # Room（親モデル）が削除されたときに、関連付けしているMessage（子モデル）は削除
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
