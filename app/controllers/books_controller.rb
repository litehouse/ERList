class BooksController < ApplicationController
  
    
  def new
      @book = Book.new
      @title = "New book"
  end

  def index
      @title = "All books"
      @per_page = params[:per_page] || Book.per_page || 15
      @books = Book.paginate(:per_page => @per_page, :page => params[:page], :order => 'title ASC')
  end

  def show
      
      begin
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error "Attempt to acess invalid book #{params[:id]}"
        redirect_to books_path, :notice => 'Invalid book'
      else
        @title = @book.title
        @book_feed_items = @book.book_feed.paginate(:page => params[:page])  
      end  
      
      #      @book = Book.find(params[:id])
      # if @book 
      #    @title = @book.title
      #    @book_feed_items = @book.book_feed.paginate(:page => params[:page])
      #    if signed_in?
      #        # @vote = Vote.new
      #        #@comment = Comment.new
      #    end
      # else
      #    flash[:notice] = "Book not found"
      #    redirect_to books_path
      # end
  end
     
    
  def create
      # @book = Book.new(params[:book])
      # @book.creator_id = current_user.id
      @book = Book.new(params[:book])
      @book.creator_id = current_user.id
      unless @book.title.nil?
        @book.title = @book.title.strip
        @book.title[0] = @book.title[0].capitalize 
      end
      unless @book.author.nil?
        @book.author = @book.author.strip    
        @book.author[0] = @book.author[0].capitalize 
      end
      if @book.save
        flash[:success] = "Book added"
        redirect_to books_path(@book)
      else
        flash[:notice] = "save failed"
        @title = "Add a Book"
        render 'new' 
      end
  end
    
  def destroy
      Book.find(params[:id]).destroy
      flash[:success] = "Book deleted"
      redirect_to books_path
  end

  def edit
      @book = Book.find(params[:id])
      @book.title = @book.title.strip
      @book.title[0] = @book.title[0].capitalize
      @book.author[0] = @book.author[0].capitalize
      @title = "Edit Book"
  end
    
  def update 
      @book = Book.find(params[:id])
      if @book.update_attributes(params[:book])
        flash[:success] = "Book updated"
        redirect_to @book
      else
        flash[:notice] = "Update failed"
        @title = "Edit book"
        render 'edit'
      end
  end
      
end

