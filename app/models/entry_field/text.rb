module EntryField
  class Text < Base

    field :value, type: String

    validates :value, presence: true, if: -> { field.required }
    validate do
      errors.add(:value, 'is too long') if value.respond_to?(:length) and
          field.max_length.present? and value.length > field.max_length
    end

  end
end