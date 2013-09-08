class UsersController < ApplicationController

  # NOTE: A before_filter runs before any action in the controller
  # -- It takes a symbol, which corresponds to a method at the end
  # -- of the controller of the same name.
  
  # NOTE: before_filter can take a hash of actions which require the
  # -- protection of before_filter.
  before_filter :signed_in_user, only: [:index, :edit, :update]
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
  end 
  
  # Actions new & create work together to create a new user
  def new
  	@user = User.new
  end

  # Method: sign_in is defined in sessions_helper.rb
  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successfull sign-in
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end 

# Actions edit & update work together to update a new user
  
  def edit
    
  end

  # Method: sign_in is defined in sessions_helper.rb
  def update
    @user = User.find(params[:id])
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
    User.find(params[:id]).destroy
    flash[:success] = "User has been relegated"
    redirect_to users_path
  end


  private
  
  # Direct users who are not logged-in to sign-in page
  # Method: signed_in? is defined in sessions_helper.rb
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice:"Whoops! Looks like you need to sign in." unless signed_in?
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: "WTF! You trying to hack my shit?" unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
