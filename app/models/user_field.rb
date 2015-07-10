class UserField < ListField

  USER_ATTRIBUTES = ['first_name', 'last_name', 'email', 'transcript_number', 'username']

  validates :name, inclusion: { in: USER_ATTRIBUTES }

end
