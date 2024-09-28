class Profile < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :birth_date, presence: true
  validates :country, :city, format: { with: /\A[a-zA-Z\s]+\z/, message: 'only letters are allowed' }

  validate :valid_country

  private

  def valid_country
    valid_countries = ISO3166::Country.all.map(&:iso_short_name)

    errors.add(:country, 'not a valid country') unless valid_countries.include?(country)
  end
end
