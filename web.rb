require 'sinatra'

require './setup'
require './lib/client'
require './lib/publisher'

init_app
PUBLISHER = Publisher.new

get '/' do
  'hello'
  #erb :index
end

get '/activity_logs/:unpacked_mac_address' do |unpacked_mac_address|
  @mac_address = [unpacked_mac_address].pack('H*')
  @activity_logs = ActivityLog.find_all_by_mac_address(@mac_address)
  calculate_secs = lambda do |start_time|
                     @activity_logs.select{|al| al.on_time > start_time}.
                                    inject(0){|secs, al| secs += al.off_time.to_i - al.on_time.to_i}
                   end
  @year_accumulate_time = calculate_secs.call Time.now.beginning_of_year
  @month_accumulate_time = calculate_secs.call Time.now.beginning_of_month
  @week_accumulate_time = calculate_secs.call Time.now.beginning_of_week
  @day_accumulate_time = calculate_secs.call Time.now.beginning_of_day
  erb :activity_logs
end

# ================================================
get '/external_devices' do
  erb :external_devices
end

post '/external_devices/:id/turn' do |id|
  case params[:on_off]
  when 'on'
    PUBLISHER.turn_on id
    for i in 0..5
      sleep(1)
      break if ExternalDevice.find_by_id(id).status == 'on'
    end
  when 'off'
    PUBLISHER.turn_off id
    for i in 0..5
      sleep(1)
      break if ExternalDevice.find_by_id(id).status == 'off'
    end
  end
  redirect '/external_devices'
end
#=================================================

post '/lights/:unpacked_mac_address' do |unpacked_mac_address|
  mac_address = [unpacked_mac_address].pack('H*')
  on_off = params[:on_off]
  c = Embedded::Client.new 'tcp://localhost:7777'
  instrument = Instrument.find_by_mac_address(mac_address)
  case on_off
  when 'on'
    if c.turn_light_on mac_address
      unless instrument.latest_on_time
        instrument.update_column :latest_on_time, Time.now 
      end
      instrument.update_column :status, 'ON'
    else
      instrument.update_column :status, 'ERROR'
    end
  when 'off'
    if c.turn_light_off mac_address
      if instrument.latest_on_time
        ActivityLog.create(mac_address: mac_address, on_time: instrument.latest_on_time, off_time: Time.now)
        instrument.update_column :latest_on_time, nil
      end
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
  instrument = Instrument.new(params[:instrument].merge(status: :unknown))
  if instrument.mac_address.size != 16
    return "the length of '#{instrument.mac_address}' is not 16"
  end
  instrument.mac_address = [instrument.mac_address].pack('H*')
  if instrument.save
    redirect '/'
  else
    "Damn #{instrument} cannot be saved"
  end
end
