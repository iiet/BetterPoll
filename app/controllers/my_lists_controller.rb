require 'csv'
class MyListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :export]
  before_action :check_user

  # GET /lists
  # GET /lists.json
  def index
    @lists = current_user.lists.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  def export
    csv = CSV.generate do |csv|
      csv << @list.list_fields.map {|f| f.name}
      @list.entries.each do |e|
        csv << @list.list_fields.map do |f|
          e.entry_fields_map[f].value
        end
      end
    end
    send_data csv, filename: "#{@list.name.parameterize}-#{Time.now.iso8601}.csv", type: 'text/csv'
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.new(new_list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to my_list_path(@list), notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: my_list_path(@list) }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(existing_list_params)
        format.html { redirect_to my_list_path(@list), notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: my_list_path(@list) }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to my_lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def check_ownership
      raise NotAuthorized if @list.owner_id != current_user.id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.lists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    COMMON_LIST_PARAMS = [
      :name, :max_entries, :max_entries_per_user, :listed,
      update_time_logic_attributes:
        [
          :id,
          :end_time_after_create,
          :start_time_absolute,
          :end_time_absolute
        ],
      destroy_time_logic_attributes:
        [
          :id,
          :end_time_after_create,
          :start_time_absolute,
          :end_time_absolute
        ],
      enroll_time_logic_attributes:
        [
          :id,
          :start_time_absolute,
          :end_time_absolute
        ],
    ]
    def new_list_params
      params.require(:list).permit(*(COMMON_LIST_PARAMS + [
      list_fields_attributes: 
        [
          :id,
          :_destroy,
          :_type,
          :name,
          :max_length,
          :required,
          :public,
          select_options_attributes:
            [
              :name,
              :id,
              :_destroy,
              :description,
              :max_entries
            ]
        ]
      ]))
    end
    def existing_list_params
      params.require(:list).permit(*COMMON_LIST_PARAMS)
    end
end
