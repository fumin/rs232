class Instrument < ActiveRecord::Base
  attr_accessible :mac_address, :room, :status, :description
end
