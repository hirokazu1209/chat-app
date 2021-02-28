class MessagesController < ApplicationController
  def index
    # Message.newで生成した、Messageモデルのインスタンス情報を代入
    @message = Message.new
    # Room.find(params[:room_id])と記述することで、paramsに含まれているroom_idを代入
    # ルーティングをネストしているため/rooms/:room_id/messagesといったパスになる。
    # パスにroom_idが含まれているため、paramsというハッシュオブジェクトの中に、room_idという値が存在。
    # →そのため、params[:room_id]と記述することでroom_idを取得。
    @room = Room.find(params[:room_id]) 
    # チャットルームに紐付いている全てのメッセージ（@room.messages）を@messagesと定義
    # 一覧画面で表示するメッセージ情報には、ユーザー情報も紐付いて表示
    # includes(:user)と記述、ユーザー情報を1度のアクセスでまとめて取得（N+1問題の解消）
    @messages = @room.messages.includes(:user)
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
      # 投稿に失敗したときの処理にも、同様に@messagesを定義
      # @messageの情報を保持しつつindex.html.erbを参照可能
      @messages = @room.messages.includes(:user)
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
