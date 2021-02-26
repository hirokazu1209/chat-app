class CreateRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :room_users do |t|
      # どのユーザーがどのチャットルームに参加しているかを管理
      # ここに保存する「ユーザー」と「チャットグループ」は必ず存在している事が前提なので、「usersテーブル」と「roomsテーブル」の情報を参照する必要
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
