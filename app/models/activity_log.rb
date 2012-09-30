class ActivityLog < ActiveRecord::Base
  attr_accessible :mac_address, :on_time, :off_time
end
