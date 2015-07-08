class ListField
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :list
  field :name, type: String

end
