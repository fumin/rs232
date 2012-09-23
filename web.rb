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

post '/lights/:mac_address' do |mac_address|
  mac_address = [mac_address].pack('H*')
  on_off = params[:on_off]
  c = Embedded::Client.new 'tcp://localhost:7777'
  instrument = Instrument.find_by_mac_address(mac_address)
  case on_off
  when 'on'
    if c.turn_light_on mac_address
      instrument.update_column :status, 'ON'
    else
      instrument.update_column :status, 'ERROR'
    end
  when 'off'
    if c.turn_light_off mac_address
      instrument.update_column :status, 'OFF'
    else
      instrument.update_column :status, 'ERROR'
    end
  end
  c.close
  redirect '/'
end

delete '/instruments/:mac_address' do |mac_address|
  mac_address = [mac_address].pack('H*')
  Instrument.find_by_mac_address(mac_address).destroy
  redirect '/'
end

post '/instruments/:mac_address' do |mac_address|
  case params[:call_method].to_sym
  when :delete; env['REQUEST_METHOD'] = "DELETE"; call! env
  else; redirect '/'
  end
end

post '/instruments' do
  @instrument = Instrument.new(params[:instrument].merge(status: :unknown))
  if @instrument.mac_address.size != 16
    return "the length of '#{@instrument.mac_address}' is not 16"
  end
  @instrument.mac_address = [@instrument.mac_address].pack('H*')
  if @instrument.save
    redirect '/'
  else
    "Damn #{@instrument} cannot be saved"
  end
end
