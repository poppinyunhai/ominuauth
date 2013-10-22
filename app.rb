require 'sinatra'
require 'omniauth'
require 'omniauth-twitter'
require 'dotenv'
require 'json'
require 'twitter'
#http://rdoc.info/gems/twitter

Dotenv.load('.env')


configure do
  enable :sessions  #not the secure session handler.  Implement Rack::Session::Cookie  in the future

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end
end

get '/auth/twitter/callback' do
  session[:oauth_token] = env['omniauth.auth']['credentials']['token']
  session[:oauth_secret] = env['omniauth.auth']['credentials']['secret']

  redirect to('/')


  Twitter.configure do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.oauth_token = session[:oauth_token]
    config.oauth_token_secret = session[:oauth_secret]
  end
end

get '/' do
  'Hello omniauth-twitter!'
  erb :index
end

post '/tweet' do
  Twitter.update("I'm tweeting with @gem!")

  redirect '/'

end