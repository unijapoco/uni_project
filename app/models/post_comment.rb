class PostComment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { in:8..500 }
end
