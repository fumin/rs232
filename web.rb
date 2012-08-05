require 'sinatra'

require './setup'
require './lib/client'

init_app

get '/' do
  erb :index
end

post '/lights' do
  on_off = params[:on_off]
  c = Embedded::Client.new 'tcp://localhost:5555'
  resp = case on_off
         when 'on'
           c.turn_light_on
         when 'off'
           c.turn_light_off
         end
puts "the response is: #{resp}"
  c.close
  resp
end
