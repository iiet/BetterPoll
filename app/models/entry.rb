class Entry
  include Mongoid::Document
  belongs_to :user
  embeds_many :entry_fields
  embedded_in :list

  accepts_nested_attributes_for :entry_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :entry_fields

   # list attributes
    # max entries
  validate do
    errors.add(:list, 'too many entries') if list.max_entries.present? and 
      list.entries.count + (new_record? ? 1 : 0) > list.max_entries
    errors.add(:list, 'you have too many entries') if list.max_entries_per_user.present? and 
      list.entries.select {|e| e.user == user}.count + (new_record? ? 1 : 0) > list.max_entries_per_user
    
  end

end
