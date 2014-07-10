# omniauth mock
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth = {
  mailchimp: OmniAuth::AuthHash.new({
    uid: 1337,
    provider: 'mailchimp',
    info: { name: 'Rocky' },
    credentials: {
      token: 'mock_token'
      },
      extra: {
        metadata: {
          dc: 'us1'
        }
      }
      }),
  paymill: OmniAuth::AuthHash.new({
    uid: 1337,
    provider: 'paymill',
    info: { name: 'Rocky' },
    credentials: {
      token: 'mock_token'
      },
      extra: {
        raw_info: {

        }
      }
      }),
  createsend: OmniAuth::AuthHash.new({
    uid: 1337,
    provider: 'createsend',
    info: { name: 'Rocky' },
    credentials: {
      token: 'mock_token',
      expires_at: 1506195251
      },
      extra: {
        info: {
          provider: 'createsend'
        }
      }
      }),
}
