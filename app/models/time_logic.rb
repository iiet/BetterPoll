class TimeLogic
  include Mongoid::Document
  embedded_in :list

  field :end_time_after_create, type: Time
  field :start_time_absolute, type: DateTime
  field :end_time_absolute, type: DateTime

  def is_allowed?(create_time = nil, time = Time.zone.now)
    start_time_absolute_condition(time) &&
    end_time_after_create_condition(create_time, time) &&
    end_time_absolute_condition(time)
  end

  def reasons(create_time = nil, time = Time.zone.now)
    reasons = []
    if start_time_absolute && !start_time_absolute_condition(time)
      reasons << "List opens on #{start_time_absolute}"
    end
    if end_time_after_create && !end_time_after_create_condition(create_time, time)
      reasons << "You are no longer able to modify your entry"
    elsif end_time_absolute && !end_time_absolute_condition(time)
      reasons << "List closed on #{end_time_absolute}"
    end
    reasons
  end

  def start_time_absolute_condition(time)
    (start_time_absolute ? start_time_absolute < time : true)
  end

  def end_time_after_create_condition(create_time, time)
    (end_time_after_create ? time <= create_time + end_time_after_create : true)
  end

  def end_time_absolute_condition(time)
    (end_time_absolute ? time <= end_time_absolute : true)
  end
end
