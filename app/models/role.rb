class Role < ApplicationRecord
  has_and_belongs_to_many :users

  DEFAULT = {
    admin: "administrator",
    user: "regular_user",
    premium: "premium_user",
    company: "company",
  }

end
