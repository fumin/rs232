require 'sinatra'

require './setup'
require './lib/client'

init_app

get '/' do
  erb :index
end

get '/fire' do
  erb :fire
end

post '/lights' do
  on_off = params[:on_off]
  c = Embedded::Client.new 'tcp://localhost:7777'
  resp = case on_off
         when 'on'
           c.turn_light_on
         when 'off'
           c.turn_light_off
         end
  c.close
  resp
end
