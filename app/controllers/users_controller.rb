class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def new
  	# debugger
  	@user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end


  def show
  	@user = User.find(params[:id])
    @topics = @user.followed_topics.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)	
  	if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

# => Note the keyword private. All private functions defined below
  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    flash[:danger] = "Aha! Only admins can delete users bro!!" unless current_user.admin?
    redirect_to root_url unless current_user.admin?
  end

end
