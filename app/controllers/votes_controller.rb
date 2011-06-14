class VotesController < ApplicationController
  
  def create
      @book = Book.find(params[:vote][:voted_id])
      current_user.vote!(@book)
      redirect_to @book
  end

  def destroy
      @book = Vote.find(params[:id]).voted
      current_user.unvote!(@book)
      redirect_to @book
  end
    
end
