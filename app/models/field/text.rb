module Field
  class Text < Base

    field :max_length, type: Integer
    field :required, type: Boolean

    validates :max_length, numericality: {only_integer: true, greater_than: 0}, if: -> { max_length.present? }
  end
end
