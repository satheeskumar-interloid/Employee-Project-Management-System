class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: "Comment added successfully."
    else
      redirect_to @commentable, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def edit 
  end 
  
  def update 
    if @comment.update(comment_params) 
      redirect_to @commentable, notice: "Comment updated successfully." 
    else 
      redirect_to @commentable, alert: @comment.errors.full_messages.to_sentence 
    end 
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_to @commentable, notice: "Comment deleted successfully."
    else
      redirect_to @commentable, alert: "You are not authorized to delete this comment."
    end
  end

  private

  def set_commentable
    if params[:project_id].present?
      @commentable = Project.find(params[:project_id])
      authorize @commentable, :show?
    elsif params[:task_id].present?
      @commentable = Task.find(params[:task_id])
      authorize @commentable, :show?
    end
  end
  def set_comment
    @comment = @commentable.comments.find(params[:id])
    authorize @comment 
  end
  def comment_params
    params.require(:comment).permit(:content)
  end
end

