require 'sinatra'
require_relative './Routes/routes'
require 'securerandom'
require 'rack/protection'


# Keep CSRF, session, etc.
use Rack::Protection::RemoteToken

use Rack::Session::Cookie,
  key: 'rack.session',
  :path => '/',
  expire_after: 2592000, # 30 days in seconds
  secret: ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }


if __FILE__ == $0
  set :port, 4567
  set :bind, '0.0.0.0'
  Sinatra::Application.run!
end
