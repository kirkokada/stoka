module OmniAuthMock
  def omniauth_test_mode! 
    OmniAuth.config.test_mode = true
  end

  def mock_omniauth_instagram
    OmniAuth.config.mock_auth[:instagram] = OmniAuth::AuthHash.new({
                                                                    provider: "instagram",
                                                                    uid: "1",
                                                                    info: {
                                                                      nickname: "username"
                                                                    },
                                                                    credentials: {
                                                                      token: "token"
                                                                    }
                                                                  })
  end

  def omniauth_reset(provider)
    OmniAuth.config.mock_auth[provider] = nil
  end
end

RSpec.configure do |c|
  c.include OmniAuthMock, omniauth: :mock
end