class CommentsController < ApplicationController
  before_action :not_logged_in
  
  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id
    flash[:errors] = 'Comment cannot be blank' unless comment.save
    redirect_to request.referrer
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end
