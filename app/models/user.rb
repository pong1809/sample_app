class User < ApplicationRecord
  attr_accessor :remember_token

  validates :name, presence: true,
                   length: { in: 1..50, too_long: I18n.t('users.warnings.max_length_50'),
                             too_short: I18n.t('users.warnings.min_length_1') }

  validates :email, presence: true, length: { maximum: Settings.max_255 },
                    format: { with: Regexp.new(Settings.VALID_EMAIL_REGEX) }, uniqueness: true

  has_secure_password

  before_save :downcase_email
  around_save :callback_around_save
  after_update :run_callback_after_update

  def callback_around_save
    Rails.logger.debug 'in around save'
    yield
    Rails.logger.debug 'out around save'
  end

  def run_callback_after_update
    Rails.logger.debug 'Callback after update is called!'
  end

  def downcase_email
    email.downcase!
  end

  class << self
    def digest(string)
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

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
