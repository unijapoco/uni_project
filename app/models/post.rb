class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :post_comments, dependent: :destroy

  validates :content, presence: true, length: { in: 8..2000 }
end
