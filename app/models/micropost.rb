class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.digit_500, Settings.digit_500]
  end

  validates :content, presence: true, length: { maximum: Settings.digit_140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: Settings.digit_5.megabytes,
                            message: 'should be less than 5MB' }

  scope :newest, -> { order created_at: :desc }
  scope :relate_post, ->(user_ids) { where user_id: user_ids }
end
