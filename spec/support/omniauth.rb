OmniAuth.config.test_mode = true

module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = {
      :provider => 'facebook',
      :uid => '1234567',
      :info => {
        :nickname => 'jbloggs',
        :email => 'joe@bloggs.com',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :image => 'http://graph.facebook.com/100006587115307/picture?type=square',
        :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
        :location => 'Palo Alto, California',
        :verified => true
        },
        :credentials => {
    :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
    :expires_at => 1321747205, # when the access token expires (it always will)
    :expires => true # this will always be true
    },
    :extra => {
      :raw_info => {
        :id => '1234567',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :link => 'http://www.facebook.com/jbloggs',
        :username => 'jbloggs',
        :location => { :id => '123456789', :name => 'Palo Alto, California' },
        :gender => 'male',
        :email => 'joe@bloggs.com',
        :timezone => -8,
        :locale => 'en_US',
        :verified => true,
        :updated_time => '2011-11-11T06:21:03+0000'
      }
    }
  }

  OmniAuth.config.mock_auth[:google_oauth2] = {
    :provider => "google_oauth2",
    :uid => "123456789",
    :info => {
      :name => "John Doe",
      :email => "john@company_name.com",
      :first_name => "John",
      :last_name => "Doe",
      :image => "http://rubyonrails.org/images/rails.png"
      },
      :credentials => {
        :token => "token",
        :refresh_token => "another_token",
        :expires_at => 1354920555,
        :expires => true
        },
        :extra => {
          :raw_info => {
            :sub => "123456789",
            :email => "user@domain.example.com",
            :email_verified => true,
            :name => "John Doe",
            :given_name => "John",
            :family_name => "Doe",
            :profile => "https://plus.google.com/123456789",
            :picture => "http://rubyonrails.org/images/rails.png",
            :gender => "male",
            :birthday => "0000-06-25",
            :locale => "en",
            :hd => "company_name.com"
          }
        }
      }

      OmniAuth.config.mock_auth[:mailchimp] =
      {
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
        }
        OmniAuth.config.mock_auth[:createsend] =
        {
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
          }
        end
      end

      RSpec.configure do |config|
  # ...
  # include our macro
  config.include(OmniauthMacros)
end
