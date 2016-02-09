class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :entry_fields, class_name: 'EntryField::Base'
  embedded_in :list

  accepts_nested_attributes_for :entry_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :entry_fields

  def entry_fields_map
    @entry_fields_map ||= Hash[entry_fields.map {|ef| [ef.field, ef]}]
  end

  def can_be_updated?(user)
    list.update_time_logic.is_allowed?(created_at) && can_execute?(user)
  end

  def can_be_destroyed?(user)
    list.destroy_time_logic.is_allowed?(created_at) && can_execute?(user)
  end

  def can_execute?(user)
    (user == list.owner) || (user == self.user)
  end

   # list attributes
    # max entries
  validate do
    list.why_cannot_enroll(user, true).each do |e|
      errors.add(:list, e)
    end
  end

end
