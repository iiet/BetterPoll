class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :new_entry, :create_entry, :iframe]
  before_action :authenticate_user!
  before_action :check_ownership, only: [:edit, :update, :destroy]

  def new_entry
    @entry = @list.entries.new(entry_fields: @list.list_fields.map { |f| f.build_entry_field })
  end

  def create_entry
    entry = @list.entries.new(entry_params.merge(user: current_user))
    entry.save
    redirect_to @list
  end

  def iframe
    render :iframe, layout: 'iframe'
  end

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  private
    def check_ownership
      raise NotAuthorized if @list.owner_id != current_user.id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, list_fields_attributes: 
        [
          :id,
          :_destroy,
          :_type,
          :name,
          :max_length,
          :required
        ])
    end

    def entry_params
      begin
        params.require(:entry).permit(entry_fields_attributes:
          [
            :_type,
            :field_id,
            :value
          ]
        )
      rescue
        {}
      end
    end
end
