class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  scope :newest, -> { order(created_at: :desc) }
  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                   foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true,
                   length: { in: Settings.digit_1..Settings.digit_50, too_long: I18n.t('users.warnings.max_length_50'),
                             too_short: I18n.t('users.warnings.min_length_1') }

  validates :email, presence: true, length: { maximum: Settings.max_255 },
                    format: { with: Regexp.new(Settings.VALID_EMAIL_REGEX) }, uniqueness: true

  validates :password, presence: true, length: { minimum: Settings.digit_6 },
                       allow_nil: true

  has_secure_password

  before_create :create_activation_digest
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

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
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
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.digit_2.hours.ago
  end

  def feed
    Micropost.relate_post(following_ids << id).includes(:user,
                                                        image_attachment: :blob)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete other_user
  end

  def following?(other_user)
    following.include? other_user
  end
end
