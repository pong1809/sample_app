class UsersController < ApplicationController
  before_action :logged_in_user, except: %i[new create]
  before_action :find_user, except: %i[index new create]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def show
    @page, @microposts = pagy @user.microposts.newest, items: Settings.digit_10
  end

  def index
    @pagy, @users = pagy User.newest, items: Settings.digit_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = 'User updated sucessfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = 'User deleted'
    else
      flash[:danger] = 'Delete fail!'
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
    flash[:warning] = 'Not found users!'
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:error] = 'You cannot edit this account.'
    redirect_to root_url
  end
end
