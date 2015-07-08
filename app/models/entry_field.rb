class EntryField
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :entry
  class InvalidCollection < Exception
  end

  field :field_id, type: BSON::ObjectId

  def entry
    _parent
  end

  def list
    _parent._parent
  end

  def field
    list.fields_map[field_id]
  end

  validate do 
    raise InvalidCollection unless entry.is_a?(Entry)
    raise InvalidCollection unless list.is_a?(List)
  end
end
