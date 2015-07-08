class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  has_many :lists, foreign_key: 'owner_id'

end
