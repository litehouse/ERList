class UsersController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :new, :create]
    before_filter :correct_user, :only => [:edit, :update]
    before_filter :admin_user, :only => :destroy
    
    
  def index
      @title = "All users"
      @per_page = params[:per_page] || User.per_page || 15
      @users = User.paginate(:per_page => @per_page, :page => params[:page],:order => 'name ASC')
      
  end
    
  def new
      @user = User.new
      @title = "Sign up"
  end
    
  def show
      
      begin
          @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
          logger.error "Attempt to acess invalid user #{params[:id]}"
          redirect_to users_path, :notice => 'Invalid user'
      else
          @title = @user.name
          @microposts = @user.microposts.paginate(:page => params[:page])  
      end  
      
      #@user = User.find(params[:id])
      #@microposts = @user.microposts.paginate(:page => params[:page])
      #@title = @user.name
  end  
    
  def create
      @user = User.new(params[:user])
      if @user.save
          sign_in @user
          flash[:success] = "Welcome to the Great War's Essential Reading List!"
          redirect_to user_path(@user)
      else
          @title = "Sign up"
          render 'new'
      end
  end
    
  def edit
      @title = "Edit user"
  end
    
  def update 
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        @title = "Edit user"
        render 'edit'
      end
  end
    
  def destroy
      @user = User.find(params[:id])
      begin
          @user.destroy
          flash[:success] = "#{@user.name} deleted"
          redirect_to users_path
      rescue Exception => e
          flash[:notice] = e.message
          redirect_to users_path
      end
  end
    
  def following
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.following.paginate(:page => params[:page])
      render 'show_follow'
  end
    
  def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(:page => params[:page])
      render 'show_follow'
  end
    
    
    

    private
    
    
      def correct_user
          @user = User.find(params[:id])
          flash[:notice] = "Unauthorized Access !! User activity on this site is logged." unless current_user?(@user)
          redirect_to(root_path) unless current_user?(@user)
      end
    
      def admin_user
          redirect_to(root_path) unless current_user.admin?
      end
                            

end
