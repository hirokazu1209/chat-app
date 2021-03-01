require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    # トップページに遷移する visitメソッドを用いて、トップページ遷移するコードを記述
    visit root_path

    # ログインしていない場合、サインインページに遷移していることを確認する
    # 「current_path」：今アクセスしているページの情報
    # expect(X).to eq(Y)メソッド：「current_path（現在のページ）」は「new_user_session_path（サインインページ）」となることを確認
    expect(current_path).to eq(new_user_session_path)
  end

  it 'ログインに成功し、トップページに遷移する' do
    # 予め、ユーザーをDBに保存する データベースにcreateメソッドでユーザーをテスト用のDBに保存
    @user = FactoryBot.create(:user)
    # サインインページへ移動する 保存したユーザーは、ログインを行っていないので、ログイン画面に遷移
    visit  new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq(new_user_session_path)

    # すでに保存されているユーザーのemailとpasswordを入力する
    # 保存したユーザーの「メールアドレス」「パスワード」をfill_inメソッドで入力
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password

    # ログインボタンをクリックする
    # click_onメソッドで「Log in」をクリックしてログイン
    click_on('Log in')

    # トップページに遷移していることを確認する
    # ログインが成功した場合は、トップページに遷移
    # ログインページ（current_path）から、トップページ（root_path）に遷移していることを確認
    expect(current_path).to eq(root_path)
  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    # データベースにcreateメソッドでユーザーを保存、保存したユーザーで、この後ログイン
    @user = FactoryBot.create(:user)
    # トップページに遷移させる
    # 保存したユーザーは、ログインを行っていないので、ログイン画面に遷移
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq(new_user_session_path)

    # 誤ったユーザー情報を入力する
    # テストではログインに失敗する挙動を、確認することが目的
    # 確実に失敗する必要があるので、どちらも'test'という文字列を入力
    fill_in 'user_email', with: 'test'
    fill_in 'user_password', with: 'test'

    # ログインボタンをクリックする
    click_on('Log in')

    # サインインページに戻ってきていることを確認する
    # ログイン失敗後は、サインインページに戻る
    expect(current_path).to eq(new_user_session_path)
  end
end