class List
  include Mongoid::Document
  # include Mongoid::OptimisticLocking

  field :name, type: String

  belongs_to :owner, class_name: 'User'
  field :owner_full_name, type: String, default: "" # cache

  has_many :users

  embeds_many :list_fields
  embeds_many :entries

  accepts_nested_attributes_for :list_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :list_fields
  validates_associated :entries
  validates_presence_of :name

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
