class Profile < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :birth_date, presence: true
  validates :country, :state, :city, format: { with: /\A[a-zA-Z\s]+\z/, message: 'only letters are allowed' },
            presence: true

  validate :valid_country
  validate :valid_state

  private

  def valid_country
    valid_countries = ISO3166::Country.all.map(&:alpha2)

    errors.add(:country, 'not a valid country') unless valid_countries.include?(country)
  end

  def valid_state
    unless ISO3166::Country[country]&.subdivisions&.key?(state)
      errors.add(:state, 'not a valid state for the selected country')
    end
  end
end
