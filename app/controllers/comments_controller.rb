class CommentsController < ApplicationController
  def create
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :body, :commentable_type)
  end
end
