class RoomsController < ApplicationController
  # チャットルームの新規作成のため「new」アクションを定義。
  # form_withに渡す引数として、値が空のRoomインスタンスを@roomに代入。
  def new
    @room = Room.new
  end
end
