class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
  length: {in: 1..50, too_long: I18n.t("users.warnings.max_length_50"),
           too_short: I18n.t("users.warnings.min_length_1")}

  validates :email, presence: true, length: {maximum: Settings.max_255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password

  before_save :downcase_email
  around_save :callback_around_save
  after_update :run_callback_after_update



  def callback_around_save
    Rails.logger.debug "in around save"
    yield
    Rails.logger.debug "out around save"
  end
  
  def run_callback_after_update
    Rails.logger.debug "Callback after update is called!"
  end

  def downcase_email
    email.downcase!
  end
end
