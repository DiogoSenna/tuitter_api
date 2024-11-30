class Tueet < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Tueet', optional: true
  has_many :replies, class_name: 'Tueet', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true, length: { maximum: user.admin? || user.premium? ? 4000 : 280 }

  scope :root_tueets, -> { where(parent_id: nil) }
  scope :reply_tueets, -> { where.not(parent_id: nil) }
end
