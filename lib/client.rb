require './lib/ffi-rzmq/lib/ffi-rzmq'

module Embedded
  class Client 
    attr_accessor :timeout
    def initialize server
      @server = server
      @context = ZMQ::Context.new(1)
      @client = nil
      @poller = ZMQ::Poller.new
      @timeout = 2500

      reconnect_to_broker
    end

    def close
      @poller.deregister @client, ZMQ::POLLIN
      @client.close
    end

    def turn_light_on
      reply = send "lights on"
      reply == "lights on OK" ? 'true' : 'false'
    end

    def turn_light_off
      reply = send "lights off"
      reply == "lights off OK" ? 'true' : 'false'
    end

    def send msg
      @client.send_string msg
      items = @poller.poll(@timeout)
      if items == 1
        message = ""
        @client.recv_string message
        return message
      end
      nil
    end

    def reconnect_to_broker
      if @client
        @poller.deregister @client, ZMQ::POLLIN
      end
  
      @client = @context.socket ZMQ::REQ
      @client.setsockopt ZMQ::LINGER, 0
      @client.connect @server
      @poller.register @client, ZMQ::POLLIN
    end
  end # class Client
end # module Embedded
