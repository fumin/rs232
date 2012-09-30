class Coordinator < ActiveRecord::Base
  attr_accessible :mac_address, :line_status, :description
  has_many :instruments, dependent: :destroy
end

