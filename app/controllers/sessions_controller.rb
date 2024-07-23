class SessionsController < ApplicationController
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)

      params.dig(:session, :remember_me) == '1' ? remember(user) : forget(user)
      log_in user
      redirect_back_or user
    else
      flash[:warning] =
        'Account not activated. Check your email for the activation link.'
      redirect_to root_path, status: :see_other
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end
end
