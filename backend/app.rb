require_relative './Routes/routes'

if __FILE__ == $0
	require 'sinatra'
	set :port, 4567
	set :bind, '0.0.0.0'
    puts "Sinatra is running on http://localhost:#{settings.port}"
	Sinatra::Application.run!
end
