class RequestsController < ApplicationController
  include EntrySearchable
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_request, only: [:show, :edit, :update]
  after_action :verify_authorized, except: [:index, :show]

  def create
    @request = Request.new
    @request.assign_attributes permitted_attributes(@request).merge(user: current_user)
    authorize @request
    if @request.save
      redirect_to @request, notice: success_message
    else
      render 'new'
    end
  end

  def complete
    @request = Request.find(params[:id])
    authorize @request
    if @request.complete!
      redirect_to :back, notice: success_message
    else
      redirect_to :back, alert: error_message
    end
  end

  def destroy
  end

  def edit
    authorize @request
  end

  def index
  end

  def my
    authorize Offer
  end

  def new
    @request = Request.new(user: current_user, postal_code: current_user.postal_code, city: current_user.city)
    authorize @request
  end

  def show
  end

  def update
    @request.assign_attributes permitted_attributes(@request)
    authorize @request
    if @request.save
      redirect_to @request, notice: success_message
    else
      render 'edit'
    end
  end

  private

  def load_request
    @request = Request.find(params[:id])
  end
end
