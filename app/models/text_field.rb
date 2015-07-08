class TextField < ListField

  field :max_length, type: Integer
  field :required, type: Boolean

  validates :max_length, numericality: { only_integer: true, greater_than: 0 }
  validates :required, inclusion: { in: [true, false] }
end
