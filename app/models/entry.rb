class Entry
  include Mongoid::Document
  belongs_to :user
  embeds_many :entry_fields
  embedded_in :list

  accepts_nested_attributes_for :entry_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :entry_fields

end
