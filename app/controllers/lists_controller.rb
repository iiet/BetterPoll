class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :new_entry, :create_entry, :iframe]
  before_action :authenticate_user!

  def new_entry
    @entry = @list.entries.new(entry_fields: @list.list_fields.map(&:build_entry_field))
  end

  def create_entry
    @entry = @list.entries.new(entry_params.merge(user: current_user))
    @entry.entry_fields << @list.list_fields.select {|a| a.is_a?(UserField) }.map(&:build_entry_field)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @list, notice: "You've been enrolled successfully" }
        # format.json { render :show, status: :created, location: my_list_path(@list) }
      else
        format.html { render :new_entry }
        # format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
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

    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
