class ExternalDevice < ActiveRecord::Base
  attr_accessible :instrument, :device_type, :latest_on_time,
                  :scheduled_on_time, :scheduled_off_time,
                  :description, :status
  belongs_to :instrument
  has_many :activity_logs

  def pin
    case device_type
    when 'relay0'; '09'
    else;          '-1'
    end
  end
end
