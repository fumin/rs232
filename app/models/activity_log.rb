class ActivityLog < ActiveRecord::Base
  attr_accessible :description, :external_device_id, :on_time, :off_time
  belongs_to :external_device
end
