require './lib/ffi-rzmq/lib/ffi-rzmq'
require './app/models/external_device'

class Publisher
  def initialize
    @context = ZMQ::Context.new
    @publisher = @context.socket ZMQ::PUB
    external_devices_count = ExternalDevice.count
    @publisher.setsockopt ZMQ::SNDHWM, external_devices_count * 10
    @publisher.bind 'tcp://*:5556'
  end

  def turn_on device_id
    talk_to_device device_id, "turn_on"
  end

  def turn_off device_id
    talk_to_device device_id, "turn_off"
  end

  def talk_to_device device_id, msg
    device = ExternalDevice.find(device_id)
    mac_address = device.instrument.mac_address
    @publisher.send_string "#{mac_address}#{device.pin} #{msg}"
  end
end
