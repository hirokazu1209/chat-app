class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # 空の場合はDBに保存しないというバリデーションを設定
  validates :name, presence: true  
  
  has_many :room_users
  has_many :rooms, through: :room_users
  # 1人のユーザーは、複数のメッセージを送信
  has_many :messages  
end
