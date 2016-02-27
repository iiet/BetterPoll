class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :new_entry, :create_entry, :iframe]
  before_action :check_user

  def iframe
    render :iframe, layout: 'iframe'
  end

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.where(:listed.in => [nil, true]).order(:created_at.desc)
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
end
