class OfferPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def create?
    @current_user.present?
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
    false
  end

  def permitted_attributes
    [:city, :description, :postal_code, :street_name, :street_number, :title, :user_id]
  end
end
