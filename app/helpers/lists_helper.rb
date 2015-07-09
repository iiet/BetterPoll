module ListsHelper
  def form_url
    action_name == 'edit' || action_name == 'update' ? my_list_path(@list) : my_lists_path
  end
end
