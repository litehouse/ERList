class UsersController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :new, :create]
    before_filter :correct_user, :only => [:edit, :update]
    before_filter :admin_user, :only => :destroy
    
    
  def index
      @title = "All users"
      @users = User.paginate(:page => params[:page]) 
  end
    
  def new
      @user = User.new
      @title = "Sign up"
  end
    
  def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(:page => params[:page])
      @title = @user.name
  end  
    
  def create
      @user = User.new(params[:user])
      if @user.save
          sign_in @user
          flash[:success] = "Welcome to the Sample App!"
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
      begin
      User.find(params[:id]).destroy
      rescue Exception => e
        flash[:notice] = e.message
        redirect_to users_path
      else
        flash[:success] = "User destroyed"
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
          flash[:notice] = "User activity on this site is logged. Please read the site guidelines." unless current_user?(@user)
          redirect_to(root_path) unless current_user?(@user)
      end
    
      def admin_user
          redirect_to(root_path) unless current_user.admin?
      end
                            

end
