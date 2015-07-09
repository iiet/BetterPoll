class BooleanEntryField < EntryField
  field :value, type: Boolean

  validates :value, inclusion: { in: [true, false] }
end
