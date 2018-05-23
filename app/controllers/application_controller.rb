class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_user
  
  
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end
  
  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login_form")
    end
  end
  
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/users/#{@current_user.id}/reader_central")
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
  	render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
  	render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end
  
end
