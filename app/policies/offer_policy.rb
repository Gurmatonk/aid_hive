class OfferPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def create?
    true
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
    true
  end

  def show?
    true
  end

  def update?
    false
  end
end
