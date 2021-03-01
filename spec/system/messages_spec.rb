require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    # 中間テーブルのレコード及びそこに紐づいているuserとroomのレコードを生成
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # DBに保存されていないことを確認する
      # チャットルームに入りメッセージを送信する際に、何も入力せずに送信したため、送信が失敗している挙動を確認
      # findメソッドを使用して、送信ボタンの「input[name="commit"]」要素を取得して、クリック
      expect {
        find('input[name="commit"]').click
        }.not_to change { Message.count }
      # 元のページに戻ってくることを確認する
      # 送信に失敗した場合は、元のページ、すなわちメッセージ一覧画面に遷移
      expect(current_path).to eq(room_messages_path(@room_user.room))
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 値をテキストフォームに入力する
      # 「テスト」という文字列を投稿フォームに入力すると仮定
      # ここで変数に代入するのは、この後の工程で再度この文字列を使用するため
      post = 'テスト'
      fill_in 'message_content', with: post
      # 送信した値がDBに保存されていることを確認する
      # 送信ボタンをクリックしたときに、messageモデルのレコードが1つ増えているかを確認
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq(room_messages_path(@room_user.room))
      # 送信した値がブラウザに表示されていることを確認する
      # 投稿後にメッセージ一覧画面に遷移していることを確認
      # expect(page).to have_content(post)で、一覧画面の中に変数postに格納されている文字列があるかどうかを確認
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      # 「Rails.root.join」でテスト用の画像のパスを生成
      # Rails.rootとすると、このRailsアプリケーションのトップ階層のディレクトリまでの絶対パスを取得
      # パスの情報に対してjoinメソッドを利用することで、引数として渡した文字列でのパス情報を、Rails.rootのパスの情報につける
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      # 添付する画像を定義して、「image_path」に代入
      # make_visible: trueを付けることで非表示になっている要素も一時的に hidden でない状態
      attach_file('message[image]', image_path, make_visible: true)

      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq(room_messages_path(@room_user.room))

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      # 「Rails.root.join」でテスト用の画像のパスを生成
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      post = 'テスト'
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end
  end
end
