class Instrument < ActiveRecord::Base
  attr_accessible :mac_address, :room
  has_many :external_devices, dependent: :destroy
end
