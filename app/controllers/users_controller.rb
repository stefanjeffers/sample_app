class UsersController < ApplicationController
  # before_filter :authenticate,  :only => [:index, :edit, :update]
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only =>  :destroy
  before_filter :signedin_user, :only => [:new, :create]

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Wine App!"
      redirect_to @user
    else
      # @user.name = ""
      # @user.email = ""
      @user.password = ""
      @user.password_confirmation = ""

      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

    # Should this be private? 
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
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

    # def authenticate
    #   deny_access unless signed_in?
    # end

    def signedin_user
      # @user = User.find(params[:id])
      # redirect_to(root_path) if current_user?(@user)
      deny_reentrance if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

        # This is changed from the tutorial version
	# because we were seeing current_user undefined in the "non-signed-in user" test case.
    def admin_user
      if current_user
        if !current_user.admin?
          redirect_to(root_path)
        else
          @user = User.find(params[:id])
          if @user == current_user
            flash[:failure] = "Warning: Attempt to destroy yourself as admin user is disallowed."
            redirect_to users_path
          end
        end
      else
        redirect_to(signin_path)
      end
    end
end

