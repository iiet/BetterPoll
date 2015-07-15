module Field
  class Base
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    embedded_in :list
    field :name, type: String
    field :public, type: Boolean, default: false

    def build_entry_field
      self.class.to_s.gsub('Field', 'EntryField').constantize.new(field_id: self.id)
    end

    validates :name, presence: true
  end
end