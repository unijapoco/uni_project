class TipComment < ApplicationRecord
  belongs_to :tip
  belongs_to :user

  validates :content, presence: true, length: { in: 8..500 }
end
