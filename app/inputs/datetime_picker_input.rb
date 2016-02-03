class DatetimePickerInput < DatePickerInput
  private

  def display_pattern
    :iso8601
  end

  def picker_pattern
    "YYYY-MM-DDTHH:mm:ssZ"
  end
end
