class Instrument < ActiveRecord::Base
  attr_accessible :mac_address, :room, :status, :description, :latest_on_time
end
