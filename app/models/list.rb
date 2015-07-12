class List
  include Mongoid::Document
  # include Mongoid::OptimisticLocking
  include Mongoid::Timestamps

  field :name, type: String
  field :max_entries, type: Integer
  field :max_entries_per_user, type: Integer, default: 1


  belongs_to :owner, class_name: 'User'
  field :owner_full_name, type: String, default: "" # cache

  has_many :users

  embeds_many :list_fields
  embeds_many :entries

  accepts_nested_attributes_for :list_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :list_fields
  validates_associated :entries
  validates_presence_of :name
  validates_numericality_of :max_entries, only_integer: true, greater_than: 0, if: -> { max_entries.present? }
  validates_numericality_of :max_entries_per_user, only_integer: true, greater_than: 0, if: -> { max_entries_per_user.present? }

  def public_list_fields
    list_fields.select {|f| f.public}
  end

  def why_cannot_enroll(user)
    reasons = []
    reasons << "too many entries on the list" if (max_entries.present? and entries.count < max_entries)
    reasons << "you made too many entries" if (max_entries_per_user.present? and
      entries.select{|e| e.user == user}.count < max_entries_per_user)
    reasons
  end


  def can_enroll?(user)
    why_cannot_enroll(user).empty?
  end

  def instant_enroll?
    list_fields.select {|f| f.class != UserField}.empty?
  end

  def is_enroled?(user)
    entries.detect {|e| e.user == user }.present?
  end

  def fields_map
    @fields_map ||= Hash[list_fields.map {|f| [f.id, f]}]
  end

  before_save do
    self.owner_full_name = owner.full_name
  end

end
