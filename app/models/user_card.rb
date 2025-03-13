class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card

  enum :role, owner: "owner", user: "user"
end
