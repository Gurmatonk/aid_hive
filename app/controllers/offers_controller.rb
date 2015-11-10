class OffersController < ApplicationController
  include EntrySearchable

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
    @offer = Offer.new(user: current_user)
    authorize @offer
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def update
  end
end
