class User < ActiveRecord::Base
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

  def instagram_authentication
    authentications.find_by_provider('instagram')
  end

  #
  # Creates an authentication from an omniauth hash
  #
  def apply_omniauth(omniauth)
    authentications.build(provider: omniauth['provider'],
                          uid:      omniauth['uid'], 
                          token:    omniauth['credentials']['token'])
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_h).find_by(
        ['lower(username) = :value OR lower(email) = :value',
         { value: login.downcase }])
    else
      find_by(conditions.to_h)
    end
  end

  def email_required?
    false
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  #
  # Returns a list of users whom a given user follows on Instagram
  #
  def instagram_follows
    auth = authentications.find_by_provider('instagram')
    return nil if auth.nil?
    client = Instagram.client(client_id: ENV['INSTAGRAM_CLIENT_ID'],
                              access_token: auth.token)
    client.user_follows(user_id: auth.uid.to_i)
  end

  #
  # Returns true if Instagram authentication credentials exist
  #
  def instagram_authenticated?
    !authentications.find_by_provider('instagram').nil?
  end
end
