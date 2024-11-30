class Tueet < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Tueet', optional: true
  has_many :replies, class_name: 'Tueet', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true
  validate :validate_content_length

  scope :root_tueets, -> { where(parent_id: nil) }
  scope :reply_tueets, -> { where.not(parent_id: nil) }

  private

  def validate_content_length
    max_length = user.admin? || user.premium? ? 4000 : 280

    errors.add(:content, "is too long (maximum is #{max_length} characters)") if content.length > max_length
  end
end
