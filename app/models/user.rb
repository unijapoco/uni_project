class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  after_create :set_default_notifications_email

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^\w{2,16}$/, :multiline => true
  validates :desc, length: { maximum: 500 }
  validates :email, uniqueness: { case_sensitive: false }, allow_blank: true, allow_nil: true

  has_many :tips, dependent: :destroy
  has_many :ons, dependent: :destroy
  has_many :tip_comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  #attr_writer :login

  #def login
  #  @login || self.username || self.email
  #end

  #def self.find_for_database_authentication(warden_conditions)
  #  conditions = warden_conditions.dup
  #  if login = conditions.delete(:login)
  #    where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #  elsif conditions.has_key?(:username) || conditions.has_key?(:email)
  #    conditions[:email].downcase! if conditions[:email]
  #    where(conditions.to_h).first
  #  end
  #end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      #user.skip_confirmation!
    end
  end

  #def self.new_with_session(params, session)
  #  super.tap do |user|
  #    if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
  #      user.email = data["email"] if user.email.blank?
  #    end
  #  end
  #end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def stats
    profit = 0
    tot_stakes = 0
    wr_num = 0
    wr_den = 0
    self.tips.settled.each do |t|
      tot_stakes += t.stake

      case t.result
      when "win"
        profit += t.stake * (t.odds - 1)
        wr_num += 1
        wr_den += 1
      when "lost"
        profit -= t.stake
        wr_den += 1
      when "halfwin"
        profit += (t.stake/2) * (t.odds - 1)
        wr_num += 0.5
        wr_den += 1
      when "halflost"
        profit -= t.stake/2
        wr_den += 0.5
      when "push"
        next
      when "void"
        tot_stakes -= t.stake
      end
    end
    { user: self,
      profit: profit,
      yield: (tot_stakes == 0? 0 : profit/tot_stakes),
      winratio: (wr_den == 0? 0 : wr_num/wr_den),
      avg_stake: (self.tips.settled.valid.count == 0? 0 : tot_stakes/self.tips.settled.valid.count),
      tips: self.tips.settled.count }
  end

  def follow(u)
    following << u
  end

  def unfollow(u)
    following.delete(u)
  end

  def following?(u)
    following.include?(u)
  end

  private
    def set_default_notifications_email
      self.notifications_email = self.email
    end
end
