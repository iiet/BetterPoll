module EntryField
  class Select < Base

    field :option_id, type: BSON::ObjectId

    def option
      @option ||= field.select_options.detect{|o| o.id == option_id}
    end

    before_validation do
      self.option_id = BSON::ObjectId.from_string option_id if option_id.is_a?(String)
    end

    def value
      @value ||= option ? option.name : ''
    end

    validates :option_id, presence: true, if: -> { field.required }
    validate do
      errors.add(:option_id, 'bad option') if option.present? && !field.select_options.map(&:id).include?(option_id)
      errors.add(:option_id, 'too many entries with this option') if option.present? && option.max_entries.present? &&
        option.count > option.max_entries
    end
  end
end