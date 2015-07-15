module EntryField
  class Boolean < Base
    field :value, type: Boolean

    validates :value, inclusion: {in: [true, false]}
  end
end