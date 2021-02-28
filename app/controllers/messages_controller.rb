class MessagesController < ApplicationController
  def index
    # Message.newで生成した、Messageモデルのインスタンス情報を代入
    @message = Message.new
    # Room.find(params[:room_id])と記述することで、paramsに含まれているroom_idを代入
    # ルーティングをネストしているため/rooms/:room_id/messagesといったパスになる。
    # パスにroom_idが含まれているため、paramsというハッシュオブジェクトの中に、room_idという値が存在。
    # →そのため、params[:room_id]と記述することでroom_idを取得。
    @room = Room.find(params[:room_id]) 
  end

  def create
    @room = Room.find(params[:room_id])
    # @room.messages.newでチャットルームに紐づいたメッセージのインスタンスを生成し、message_paramsを引数にして、privateメソッドを呼び出し    
    # 生成したインスタンスを@messageに代入
    @message = @room.messages.new(message_params)
    # saveメソッドでメッセージの内容をmessagesテーブルに保存
    if @message.save
      # 成功：redirect_toメソッドを用いてmessagesコントローラーのindexアクションに再度リクエストを送信し、新たにインスタンス変数を生成
      redirect_to room_messages_path(@room)
    else
      # 失敗：renderメソッドを用いてindexアクションのindex.html.erbを表示するように指定。
      # このとき、indexアクションのインスタンス変数はそのままindex.html.erbに渡され、同じページに戻る
      render :index
    end
  end

  private
  # message_paramsを定義し、メッセージの内容contentをmessagesテーブルへ保存
  # パラメーターの中に、ログインしているユーザーのidと紐付いている、メッセージの内容contentを受け取れるように許可
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end
