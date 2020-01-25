class Post < ApplicationRecord
  belongs_to :user

  has_many :post_comments, dependent: :destroy

  validates :content, presence: true, length: { in: 8..2000 }
end
