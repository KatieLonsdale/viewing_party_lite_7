# controller for users in database
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to "/users/#{@user.id}"
    else
      redirect_to "/register"
      flash[:alert] = "All fields must be filled out and email must be unique"
    end
  end

  def dashboard
    @user = User.find(params[:user_id])
    @facade = MovieFacade.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
