class User < ApplicationRecord
    attr_accessor :remember_token
  
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
  
    class << self
      def digest string
        cost = if ActiveModel::SecurePassword.min_cost
                 BCrypt::Engine::MIN_COST
               else
                 BCrypt::Engine.cost
               end
        BCrypt::Password.create string, cost:
      end
  
      def new_token
        SecureRandom.urlsafe_base64
      end
    end
  
    def remember
      self.remember_token = User.new_token
      update_column :remember_digest, User.digest(remember_token)
    end
  
    def authenticated? remember_token
      BCrypt::Password.new(remember_digest).is_password? remember_token
    end
  
    def forget
      update_column :remember_digest, nil
    end
  end