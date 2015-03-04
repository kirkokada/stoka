class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  # Constants

  VALID_USERNAME_REGEX = /\A\w+\z/i

  # Validations

  validates :username, presence: true, 
                       format: { with: VALID_USERNAME_REGEX }, 
                       uniqueness: { case_sensitive: false }

  has_many :authentications, dependent: :destroy

  def apply_omniauth(omniauth)
    username = omniauth['info']['nickname']
    provider = omniauth['provider']
    uid = omniauth['uid']
    token = omniauth['credentials']['token']
    authentications.build(provider: provider, uid: uid, token: token)
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def email_required?
    false
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
