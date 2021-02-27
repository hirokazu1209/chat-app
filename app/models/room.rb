class Room < ApplicationRecord
  has_many :room_users
  has_many :users, through: :room_users
  # 1つのチャットルームに、メッセージは複数存在
  has_many :messages

  validates :name, presence: true
end
