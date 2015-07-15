module Field
  class Select < Base
    embeds_many :select_options, class_name: 'Field::SelectOption'
    accepts_nested_attributes_for :select_options, :reject_if => :all_blank, :allow_destroy => true

    field :required, type: Boolean

    validates_associated :select_options
    validates_presence_of :select_options
  end
end
