class RequestsController < ApplicationController
  before_action :set_query, only: [:index]
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
    @requests = Request.all.page(params[:page])
    @requests = @requests.fuzzy_search({title: @query, description: @query}, false) if @query.present?
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
