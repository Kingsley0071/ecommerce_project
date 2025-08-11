class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @product, notice: "Comment added."
    else
      redirect_to @product, alert: "Comment can't be blank."
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @product, notice: "Comment updated."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @product, notice: "Comment deleted."
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end

  def authorize_user!
    unless current_user == @comment.user || current_user.admin?
      redirect_to @product, alert: "Not authorized."
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end