FactoryBot.define do
  factory :room_user do
    # associationメソッドは、FactoryBotによって生成されるモデルを関連づけるメソッド
    association :user
    association :room
  end
end