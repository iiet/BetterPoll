class EntryField
  include Mongoid::Document
  embedded_in :entry
  class InvalidCollection < Exception
  end

  field :field_id, type: BSON::ObjectId

  def entry
    _parent_document
  end

  def list
    _parent_document._parent_document
  end

  def field
    list.fields_map[field_id]
  end

  validate do 
    raise InvalidCollection unless entry.is_a?(Entry)
    raise InvalidCollection unless list.is_a?(List)
  end
end
