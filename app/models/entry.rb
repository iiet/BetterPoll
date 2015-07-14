class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :entry_fields
  embedded_in :list

  accepts_nested_attributes_for :entry_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :entry_fields

  def entry_fields_map
    @entry_fields_map ||= Hash[entry_fields.map {|ef| [ef.field, ef]}]
  end

   # list attributes
    # max entries
  validate do
    errors.add(:list, 'too many entries') if list.max_entries.present? and 
      list.entries.count > list.max_entries
    errors.add(:list, 'you have too many entries') if list.max_entries_per_user.present? and 
      list.entries.select {|e| e.user == user}.count> list.max_entries_per_user
  end

end
