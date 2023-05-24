class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to ("/dashboard")
    else
      redirect_to(new_session_path)
      flash[:alert] = "Incorrect credentials."
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
