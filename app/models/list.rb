class List
  include Mongoid::Document
  # include Mongoid::OptimisticLocking

  field :name, type: String

  belongs_to :owner, class_name: 'User'
  has_many :users

  embeds_many :list_fields
  embeds_many :entries

  accepts_nested_attributes_for :list_fields, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :list_fields
  validates_associated :entries
  validates_presence_of :name

  def fields_map
    @fields_map ||= Hash[fields.map {|f| [f.id, f]}]
  end

end
