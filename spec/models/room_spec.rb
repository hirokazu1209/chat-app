require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#create' do
    before do
      @room = FactoryBot.build(:room)
    end

    it 'nameの値が存在すれば登録できること' do
      # チャットルームの情報が正しく保存されるか確認
      expect(@room).to be_valid
    end

    it 'nameが空では登録できないこと' do
      # モデルファイルで設定したバリデーション（もしroomのネームが空だったらDBに保存されない）が正常に起動するかを確認
      @room.name = ''
      @room.valid?
      # DBに保存されない場合のエラーメッセージは「Name can't be blank（nameを入力してください）」
      expect(@room.errors.full_messages).to include("Name can't be blank")
    end
  end
end