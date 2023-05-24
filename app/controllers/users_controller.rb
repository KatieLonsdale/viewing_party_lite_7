# controller for users in database
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if user_params[:password] != user_params[:password_confirmation]
      redirect_to "/register"
      flash[:alert] = "Passwords must match"
    elsif @user.save
      session[:user_id] = @user.id
      redirect_to "/dashboard"
    else
      redirect_to "/register"
      flash[:alert] = "All fields must be filled out and email must be unique"
    end
  end

  def dashboard
    if !current_user
      flash[:alert] = "You must be logged in to access your dashboard"
      redirect_to root_path
    else
      @user = User.find(session[:user_id])
      @facade = MovieFacade.new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
