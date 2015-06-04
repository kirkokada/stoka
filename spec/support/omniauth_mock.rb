module OmniAuthMock
  def omniauth_test_mode!
    OmniAuth.config.test_mode = true
  end

  def mock_omniauth_instagram
    omniauth_test_mode!
    OmniAuth.config.mock_auth[:instagram] = OmniAuth::AuthHash.new(
      provider: 'instagram',
      uid: ENV['INSTAGRAM_UID'],
      info: {
        nickname: ENV['INSTAGRAM_USERNAME']
      },
      credentials: {
        token: ENV['INSTAGRAM_ACCESS_TOKEN']
      })
  end

  def omniauth_reset(provider)
    OmniAuth.config.mock_auth[provider] = nil
  end
end

RSpec.configure do |c|
  c.include OmniAuthMock
end
