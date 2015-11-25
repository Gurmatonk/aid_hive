class RequestPolicy
  attr_reader :current_user, :request

  def initialize(current_user, model)
    @current_user = current_user
    @request = model
  end

  def create?
    current_user.present?
  end

  def complete?
    current_user == request.user && request.may_complete?
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
