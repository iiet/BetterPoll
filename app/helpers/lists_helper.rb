module ListsHelper
  def form_url
    action_name == 'edit' || action_name == 'update' ? my_list_path(@list) : my_lists_path
  end

  def user_public_fields_msg(list)
    fields = list.public_list_fields(Field::User)
    fields.count > 0 ? "You will publicly share your #{fields.map(&:name).join(', ')}" : nil
  end
end
