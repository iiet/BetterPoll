class TimeLogic
  include Mongoid::Document
  embedded_in :list

  field :end_time_after_create, type: Time
  field :start_time_absolute, type: DateTime
  field :end_time_absolute, type: DateTime

  def is_allowed?(create_time = nil, time = Time.zone.now)
    (start_time_absolute ? start_time < time : true) &&
    (end_time_after_create ? time <= create_time + end_time_after_create : true) &&
    (end_time_absolute ? time <= end_time_absolute : true)
  end 
end
