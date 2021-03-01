require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    before do
      @message = FactoryBot.build(:message)
    end

    it 'contentとimageが存在していれば保存できること' do
      # contentとimageの両方が存在していれば、DBに正しく保存されるかを確認
      expect(@message).to be_valid
    end

    it 'contentが空でも保存できること' do
      # contentが空でも（imageが存在していれば）、DBに正しく保存されるかを確認
      @message.content = ''
      expect(@message).to be_valid
    end

    it 'imageが空でも保存できること' do
      # imageが空でも（contentが存在していれば）、DBに正しく保存されるかを確認
      @message.image = nil
      expect(@message).to be_valid
    end

    it 'contentとimageが空では保存できないこと' do
      # モデルファイルで設定したバリデーション（もしcontentとimageが空だったらDBに保存されない）が正常に起動するかを確認
      @message.content = ''
      @message.image = nil
      @message.valid?
      # DBに保存されない場合のエラーメッセージは「Content can't be blank（Contentを入力してください）」
      expect(@message.errors.full_messages).to include("Content can't be blank")
    end

    it 'roomが紐付いていないと保存できないこと' do
      # アソシエーションによって@messageに紐づいているroomを空にした上で、バリデーションを確認
      @message.room = nil
      @message.valid?
      # エラーメッセージはRoom must exist
      expect(@message.errors.full_messages).to include('Room must exist')
    end

    it 'userが紐付いていないと保存できないこと' do
      # アソシエーションによって@messageに紐づいているuserを空にした上で、バリデーションを確認
      @message.user = nil
      @message.valid?
      # エラーメッセージはUser must exist
      expect(@message.errors.full_messages).to include('User must exist')
    end
  end
end