class GoalsController < ApplicationController
  before_action :not_logged_in

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find_by_id(params[:id])

    if @goal
      render :show
    else
      redirect_to users_url
    end
  end

  def edit
    @goal = Goal.find_by_id(params[:id])

    if @goal && @goal.user_id == current_user.id
      render :edit
    else
      redirect_to users_url
    end
  end

  def update
    @goal = Goal.find_by_id(params[:id])
    return unless @goal.user_id == current_user.id

    if @goal.update_attributes(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    goal = Goal.find_by_id(params[:id])
    return unless goal.user_id == current_user.id
    user_id = goal.user_id
    goal.destroy
    redirect_to user_url(user_id)
  end

  private

  def goal_params
    params.require(:goal).permit(:private, :completed, :title, :body, :cheers)
  end
end
