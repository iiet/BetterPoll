module Field
  class SelectOption
    include Mongoid::Document
    embedded_in :select

    field :name, type: String
    field :max_entries, type: Integer
    field :description, type: String

    validates :name, presence: true
    validates :max_entries, numericality: {only_integer: true, greater_than: 0}, if: -> { max_entries.present? }

    def count
      @count ||= select.list.entries.map {|e| e.entry_fields.detect{|ef| ef.field == select}}.
        select{|ef| ef.option_id == id}.count
    end
  end
end
