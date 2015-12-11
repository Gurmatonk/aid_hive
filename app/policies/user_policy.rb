class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def edit?
    self_or_admin?
  end

  def destroy?
    return false if current_user == user
    current_user.admin?
  end

  def index?
    current_user.admin?
  end

  def show?
    self_or_admin?
  end

  def update?
    edit?
  end

  def permitted_attributes
    attributes = [:city, :name, :postal_code, :street_name, :street_number]
    attributes += [:role] if user.admin? && user != current_user
    attributes
  end

  private

  def self_or_admin?
    current_user.present? && (current_user.admin? || current_user == user)
  end
end
