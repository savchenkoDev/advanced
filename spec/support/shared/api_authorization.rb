RSpec.shared_examples_for "API authenticable" do
  it '- returns 401 status if there is no access_token' do
    send_request
    expect(response).to have_http_status(401)
  end

  it '- returns 401 status if access_token is invalid' do
    send_request(access_token: '1234')
    expect(response).to have_http_status(401)
  end
end