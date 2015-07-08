class UserEntryField < EntryField

  field :value, type: String

  before_validation do
    self.value = entry.user[field.name]
  end

end
