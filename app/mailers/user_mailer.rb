class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user

    mail to: user.email, subject: t('mailer.subject.account_activation')
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: t('mailer.password_reset.subject')
  end
end
