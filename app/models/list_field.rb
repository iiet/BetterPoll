class ListField
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :list
  field :name, type: String

  def build_entry_field
    self.class.to_s.gsub('Field', 'EntryField').constantize.new(field_id: self.id)
  end
end
