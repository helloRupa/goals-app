class UsersController < ApplicationController
  before_action :not_logged_in, only: [:index, :show]
  before_action :already_logged_in, only: [:new, :create]

  def index
    render :index
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user
      render :show
    else
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
