class EntriesController < ApplicationController
  before_action :set_list
  before_action :check_user
  before_action :set_entry, only: [:edit, :update, :destroy]

  def new
    @entry = @list.entries.new(entry_fields: @list.list_fields.map(&:build_entry_field))
  end

  def create
    @entry = @list.entries.new(entry_params.merge(user: current_user))
    @entry.entry_fields << @list.list_fields.select {|a| a.is_a?(Field::User) }.map(&:build_entry_field)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @list, notice: "You've been enrolled successfully" }
        # format.json { render :show, status: :created, location: my_list_path(@list) }
      else
        format.html { render :new }
        # format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    raise NotAuthorized unless @entry.can_be_updated?(current_user)
  end

  def destroy
    raise NotAuthorized unless @entry.can_be_destroyed?(current_user)
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to list_path(@list), notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update
    raise NotAuthorized unless @entry.can_be_updated?(current_user)
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to list_path(@list), notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: list_entry_path(@entry) }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_list
      @list = List.find(params[:list_id])
    end

    def set_entry
      @entry = @list.entries.detect {|e| e.id == BSON::ObjectId(params[:id])}
    end

    def entry_params
      begin
        params.require(:entry).permit(entry_fields_attributes:
          [
            :_type,
            :field_id,
            :value,
            :option_id
          ]
        )
      rescue
        {}
      end
    end
end
