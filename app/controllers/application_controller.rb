class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # 定義されたconfigure_permitted_parametersが実行 定義しないと以下内容が読み込まれない
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  # 初期設定の段階では、メールアドレスとパスワードのみを受け取るように設定している。
  # 新しいキーをコントローラに追加するために、ストロングパラメーターを編集
  # nameの追加
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
