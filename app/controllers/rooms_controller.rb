class RoomsController < ApplicationController
  def index
  end
  
  # チャットルームの新規作成のため「new」アクションを定義。
  # form_withに渡す引数として、値が空のRoomインスタンスを@roomに代入。
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    # createアクション内の記述も保存の成功・失敗による条件分岐が必要
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    # Room.find(params[:id])を使用して、削除したいチャットルームの情報を取得
    room = Room.find(params[:id])
    # インスタンス変数ではなく変数としてroomを定義し、destroyメソッドを使用
    room.destroy
    # root（roomsのindex）にリダイレクトする記述
    redirect_to root_path
  end

  private

  def room_params
    # 配列に対して保存を許可したい場合は、キーに対し[]を値として記述
    params.require(:room).permit(:name, user_ids: [])
  end  

end
