require './lib/ffi-rzmq/lib/ffi-rzmq'
require './setup'

class EmbeddedUtils
  def self.get_status uint32_bitstr, device_type
    puts(uint32_bitstr)
    case device_type
    when 'relay0'; on_off_from_01(uint32_bitstr.reverse[8])
    else; 'unknown'
    end
  end

  def self.on_off_from_01 zero_one
    zero_one == '0' ? 'off' : 'on'
  end
end

init_app

context = ZMQ::Context.new
puller = context.socket ZMQ::PULL
external_devices_count = ExternalDevice.count
puller.setsockopt ZMQ::RCVHWM, external_devices_count * 10
puller.bind 'tcp://*:5555'
msg = ''
loop do
  rc = puller.recv_string msg
  next unless rc > 0
  m = msg.unpack('B32a8')
  instrument = Instrument.find_by_mac_address m[1]
  next unless instrument
  device = ExternalDevice.where('instrument_id=? AND device_type=?',
                                instrument.id, 'relay0').first
  next unless device
  status = EmbeddedUtils.get_status(m[0], 'relay0')
  if status != device.status
    puts "UPDATE device #{device.id} to #{status}!"
    device.update_column :status, status
  end
end
