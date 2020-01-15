class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^\w{2,16}$/, :multiline => true

  has_many :tips, dependent: :destroy

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

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
end
