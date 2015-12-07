class OfferPolicy
  attr_reader :current_user, :offer

  def initialize(current_user, model)
    @current_user = current_user
    @offer = model
  end

  def create?
    current_user.present?
  end

  def complete?
    current_user == offer.user && offer.may_complete?
  end

  def destroy?
    false
  end

  def edit?
    true
  end

  def index?
    true
  end

  def new?
    create?
  end

  def show?
    true
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:city, :description, :postal_code, :street_name, :street_number, :title, :user_id]
  end
end
