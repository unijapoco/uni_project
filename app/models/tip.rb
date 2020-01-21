class Tip < ApplicationRecord
  belongs_to :user

  validates :desc, :odds, :stake, presence: true
  validates :odds, numericality: { greater_than: 1 }
  validates :stake, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10}

  enum result: [ :pending, :win, :lost, :halfwin, :halflost, :push, :void ]

  has_many :ons, dependent: :destroy
  has_many :tip_comments, dependent: :destroy

  scope :settled, -> { not_pending }
end
