FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name { 'Test'}
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { rand(999999) }
    secret { rand(999999) }
  end
end