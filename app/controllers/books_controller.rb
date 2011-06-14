class BooksController < ApplicationController
  
    
  def new
      @book = Book.new
  end

  def index
      @title = "All books"
      @books = Book.paginate(:page => params[:page]) 
  end

  def show
      @book = Book.find(params[:id])
      @title = @book.title
      @book_feed_items = @book.book_feed.paginate(:page => params[:page])
      if signed_in?
          @vote = Vote.new
          @comment = Comment.new
      end
  end
     
  def create
      @book = Book.new(params[:book])
      @book.creator_id = current_user.id
      if @book.save
          flash[:success] = "Book added!"
          redirect_to books_path(@book)
      else
          redirect_to books_path
      end
  end
    
  def destroy
      Book.find(params[:id]).destroy
      flash[:success] = "Book destroyed"
      redirect_to books_path
  end

  def edit
      @book = Book.find(params[:id])
      @title = "Edit Book"
  end
    
  def update 
      @book = Book.find(params[:id])
      if @book.update_attributes(params[:book])
          flash[:success] = "Book updated"
          redirect_to @book
      else
          @title = "Edit book"
          render 'edit'
      end
  end
      
end
