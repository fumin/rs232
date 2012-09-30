class Instrument < ActiveRecord::Base
  attr_accessible :mac_address, :room, :coordinator, :line_status, :parent_id 
  has_many :external_devices, dependent: :destroy
  belongs_to :coordinator
end
