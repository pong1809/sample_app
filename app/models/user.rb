class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
    validates :name, presence: true,
    length: {in: 1..50, too_long: "50 characters is the maximum allowed",
             too_short: "1 character is the minimum allowed"}
  
    validates :email, presence: true, length: {maximum: 255},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  
    has_secure_password
  
    before_save :downcase_email
    around_save :callback_around_save
    after_update :run_callback_after_update
  
    def run_callback_after_update
      Rails.logger.debug "Callback after update is called!"
    end
  
    def callback_around_save
      Rails.logger.debug "in around save"
      yield
      Rails.logger.debug "out around save"
    end
  
    def downcase_email
      email.downcase!
    end
  
    def self.digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end
  end