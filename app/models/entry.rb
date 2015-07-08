class Entry
  include Mongoid::Document
  belongs_to :user
  embeds_many :entry_fields
  embedded_in :list

  validates_associated :entry_fields

end
