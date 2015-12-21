class OffersController < ApplicationController
  include EntrySearchable
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show]

  def complete
    @offer = Offer.find(params[:id])
    authorize @offer
    if @offer.complete!
      redirect_to :back, notice: success_message
    else
      redirect_to :back, alert: error_message
    end
  end

  def create
    @offer = Offer.new
    @offer.assign_attributes permitted_attributes(@offer)
    authorize @offer
    if @offer.save
      redirect_to @offer, notice: success_message
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
    @offer = Offer.new(user: current_user, postal_code: current_user.postal_code, city: current_user.city)
    authorize @offer
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def update
  end
end
