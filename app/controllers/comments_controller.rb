class CommentsController < ApplicationController
  
    def create
        @comment = current_user.comments.build(params[:comment])
        @book = Book.find_by_id(params[:comment][:book_id])
        if @comment.save
            flash[:success] = "Comment created!"
            redirect_to @book
        else
            redirect_to root_path
        end
    end
    
    def destroy
        @comment = Comment.find(params[:id])
        @book = @comment.book
        @comment.destroy
        redirect_to @book
    end

end
