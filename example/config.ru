require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-soundcloud'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/soundcloud'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
  
  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :soundcloud, ENV['APP_ID'], ENV['APP_SECRET'], :scope => 'non-expiring'
end

run App.new
