class ExternalDevice < ActiveRecord::Base
  attr_accessible :instrument, :device_type, :latest_on_time, :scheduled_on_time, :scheduled_off_time, :description, :status
  belongs_to :instrument
  has_many :activity_logs
end
