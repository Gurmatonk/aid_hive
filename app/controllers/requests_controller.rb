class RequestsController < ApplicationController
  include EntrySearchable
  after_action :verify_authorized, :except => [:index, :show]

  def create
    @request = Request.new
    @request.assign_attributes permitted_attributes(@request)
    authorize @request
    if @request.save
      redirect_to @request, notice: success_message
    else
      render 'new'
    end
  end

  def destroy
  end

  def edit
  end

  def index
  end

  def new
    @request = Request.new(user: current_user)
    authorize @request
  end

  def show
    @request = Request.find(params[:id])
  end

  def update
  end
end
