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

  embeds_many :list_fields, class_name: 'Field::Base'
  embeds_many :entries
  embeds_one :update_time_logic, class_name: 'TimeLogic', autobuild: true
  embeds_one :destroy_time_logic, class_name: 'TimeLogic', autobuild: true
  embeds_one :enroll_time_logic, class_name: 'TimeLogic', autobuild: true

  accepts_nested_attributes_for :list_fields, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :update_time_logic, :enroll_time_logic, :destroy_time_logic

  validates_associated :list_fields
  validates_associated :entries
  validates_presence_of :name, :list_fields
  validates_numericality_of :max_entries, only_integer: true, greater_than: 0, if: -> { max_entries.present? }
  validates_numericality_of :max_entries_per_user, only_integer: true, greater_than: 0, if: -> { max_entries_per_user.present? }

  before_save do
    self.owner_full_name = owner.full_name
  end

  def entries_by(user)
    entries.select {|e| e.user == user}
  end

  def public_list_fields(type = nil)
    @fields = list_fields.select {|f| f.public}
    @fields.select! {|f| f.is_a?(type)} if type.present?
    @fields
  end

  def why_cannot_enroll(user, new_record = false)
    reasons = []
    reasons << "too many entries on the list" if (max_entries.present? &&
      entries.count + (new_record ? 0 : 1) > max_entries)
    reasons << "you made too many entries" if (max_entries_per_user.present? &&
      entries.select{|e| e.user_id == user.id}.count + (new_record ? 0 : 1) > max_entries_per_user)
    reasons += enroll_time_logic.reasons
    reasons
  end

  def can_enroll?(user)
    why_cannot_enroll(user).empty? && enroll_time_logic.is_allowed?
  end

  def instant_enroll?
    list_fields.select {|f| !f.is_a?(Field::User)}.empty?
  end

  def is_enroled?(user)
    entries.detect {|e| e.user == user }.present?
  end

  def fields_map
    @fields_map ||= Hash[list_fields.map {|f| [f.id, f]}]
  end

  def iframe_embed_code
    "<iframe src=\"#{Rails.application.routes.url_helpers.iframe_list_url(self)}\" style=\"width:500px; height: 70px; border:none;\"></iframe>"
  end

  def bbcode_embed_code
    "[betterpoll=#{self.id}][/betterpoll]"
  end
end
