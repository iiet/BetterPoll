class UserField < ListField

  USER_ATTRIBUTES = ['first_name', 'last_name', 'email', 'transcript_number', 'username']

  field :name, type: String

  validates :name, presence: true, inclusion: { in: USER_ATTRIBUTES }

end
