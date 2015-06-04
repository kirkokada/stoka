class MediaFetcher
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :ig_username, :ig_access_token

  VALID_IG_USERNAME = /\A[\w]+\z/

  validates :ig_profile,
            presence: { message: 'No matching user found.' }
  validates :ig_recent_media,
            presence: { message: 'No location data found for this username.' }

  before_validation :remove_at_sign
  before_validation :ig_profile

  def ig_client
    @ig_client ||= Instagram.client(ig_credentials)
  end

  def ig_credentials
    creds = { client_id: ENV['INSTAGRAM_CLIENT_ID'],
              client_secret: ENV['INSTAGRAM_CLIENT_SECRET'] }
    creds[:ig_access_token] = ig_access_token unless ig_access_token.nil?
    creds
  end

  def ig_profile
    return if ig_username.blank?
    @ig_profile ||= ig_client.user_search(ig_username, count: 1).first
  end

  def ig_recent_media
    @ig_recent_media ||= media_with_location
  end

  def ig_subscriptions
    ig_client.subscriptions
  end

  private

  def remove_at_sign
    return if ig_username.blank?
    self.ig_username = ig_username[1..-1] if ig_username.first == '@'
  end

  def media_with_location
    return nil if ig_profile.nil?
    media = ig_client.user_recent_media(ig_profile.id)
    media.select { |m| !m['location'].nil? }
    rescue Instagram::BadRequest
      errors[:base] << 'Could not access data for this username.'
  end
end
