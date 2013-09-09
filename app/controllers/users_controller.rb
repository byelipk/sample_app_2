class UsersController < ApplicationController

  # NOTE: A before_filter runs before any action in the controller
  # -- It takes a symbol, which corresponds to a private method of the controller
  
  # NOTE: before_filter can take a hash of actions which require the
  # -- protection of before_filter.
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  # NOTE: Instance variables ALWAYS start off with a value of NIL
  # -- Make sure to define an instance variable within each action,
  # -- else you will receive an error when you try to access
  # -- properties within the corresponding template similar to this: 
  # -- NoMethodError: undefined method `model_xxxxx' for NilClass:Class
  # -- where 'model_xxxx' refers to the name of the property you
  # -- are trying to access. It could be 'model_name', 'model_email', etc...



  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end 
  

  def new
    if signed_in?
        redirect_to current_user
    else
      @user = User.new
    end
    # @user = User.new
  end

  def create
    if signed_in?
        redirect_to current_user
    else
      @user = User.new(params[:user])
    end
    #@user = User.new(params[:user])
    
    if @user.save
      # Handle a successfull sign-in
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end 


  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      # Handle a successfull update
      
      # We need to sign-in the user to update
      # their remember_token to avoid a session hijack
      flash[:success] = "Profile updated!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    user = User.find(params[:id])
    if user.admin == false
      user.destroy
      flash[:success] = "User has been relegated"
      redirect_to users_path
    else
      flash[:success] = "Admin users cannot be deleted"
      redirect_to users_path
    end

  end


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: "WTF! You trying to hack my shit?" unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
