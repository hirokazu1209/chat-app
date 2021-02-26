class UsersController < ApplicationController

  def edit
  end  

  def update
    if current_user.update(user_params)
      # 成功した場合、root（チャット画面）にリダイレクト
      redirect_to root_path
    else
      # 失敗した場合、editのアクションを指定→editのビューが表示されます。
      render :edit
    end  
  end
  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
