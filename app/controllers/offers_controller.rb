class OffersController < ApplicationController
  include EntrySearchable
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_offer, only: [:show, :edit, :update]
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
    @offer.assign_attributes permitted_attributes(@offer).merge(user: current_user)
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
    authorize @offer
  end

  def index
  end

  def my
    authorize Offer
  end

  def new
    @offer = Offer.new(user: current_user, postal_code: current_user.postal_code, city: current_user.city)
    authorize @offer
  end

  def show
  end

  def update
    @offer.assign_attributes permitted_attributes(@offer)
    authorize @offer
    if @offer.save
      redirect_to @offer, notice: success_message
    else
      render 'edit'
    end
  end

  private

  def load_offer
    @offer = Offer.find(params[:id])
  end
end
