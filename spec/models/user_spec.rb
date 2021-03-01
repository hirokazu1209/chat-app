require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end  
    
    it 'nameとemail、passwordとpassword_confirmationが存在すれば登録できること' do
      # 上記条件が満たしていれば、データベースに正しく保存されるか確認
      expect(@user).to be_valid
    end

    it 'nameが空では登録できないこと' do
      # モデルファイルで設定したバリデーション（もしuserのnameが空だったらDBに保存されない）が正常に起動するかを確認
      @user.name = ''
      @user.valid?
      # errorsメソッド：インスタンスにエラーを示す情報がある場合、その内容を返す
      # full_messagesメソッド：エラーの内容から、エラーメッセージを配列として取り出す
      # includeマッチャ：「expectの引数」に「includeの引数」が含まれていることを確認
      # DBに保存されない場合のエラーメッセージは、「Name can't be blank（nameを入力してください）」
      expect(@user.errors.full_messages).to include("Name can't be blank") 
    end

    it 'emailが空では登録できないこと' do
      # nameと同様の考え方
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'passwordが空では登録できないこと' do
      # nameと同様の考え方
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    
    it 'passwordが6文字以上であれば登録できること' do
      # 「123456」は、今回の条件に合うように仮置きの値として指定した文字列
      # データベースに保存されるかを確認
      @user.password = '123456'
      @user.password_confirmation = '123456'
      expect(@user).to be_valid
    end

    it 'passwordが5文字以下であれば登録できないこと' do
      @user.password = '12345'
      @user.password_confirmation = '12345'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'passwordとpassword_confirmationが不一致では登録できないこと' do
      @user.password = '123456'
      @user.password_confirmation = '1234567'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it '重複したemailが存在する場合登録できないこと' do
      # user情報をデータベースに保存する記述
      @user.save
      # FactoryBotを用いて、user情報（name、email、password、password_confirmation）の中でも「email」だけを選択してインスタンスを生成
      another_user = FactoryBot.build(:user, email: @user.email)
      another_user.valid?
      # 保存しようとしているemailが既にDBに存在している場合は「Email has already been taken（そのEmailは既に使われています）」というエラー文が表示
      expect(another_user.errors.full_messages).to include('Email has already been taken')
    end
  end
end
