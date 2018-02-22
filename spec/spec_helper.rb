require 'webmock/rspec'
require 'json'
require 'pry'
require './git_client'

WebMock.disable_net_connect!

contributors = File.new(File.absolute_path('spec/fixtures/contributors.json')).read
user = File.new(File.absolute_path('spec/fixtures/user.json')).read

RSpec.configure do |config|
  config.before do
    stub_request(:get, "https://api.github.com/repos/Dinda-com-br/braspag-rest/contributors?access_token=abc123").
      with(  headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'=>'api.github.com',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: contributors, headers: {})

    ['pmatiello', 'bvicenzo', 'antoniofilho'].each do |username|
      stub_request(:get, "https://api.github.com/users/#{username}?access_token=abc123").
        with(  headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'api.github.com',
          'User-Agent'=>'Ruby'
        }).

      to_return(status: 200, body: user, headers: {})
    end
  end
end
