module Field
  class User < Base

    USER_ATTRIBUTES = %w(first_name last_name email transcript_number username)

    validates :name, inclusion: {in: USER_ATTRIBUTES}
  end
end
