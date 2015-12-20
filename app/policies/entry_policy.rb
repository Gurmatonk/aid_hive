class EntryPolicy
  attr_reader :current_user, :entry

  def initialize(current_user, model)
    @current_user = current_user
    @entry = model
  end

  def create?
    current_user.present? && entry.user == current_user
  end

  def complete?
    owner_or_admin? && entry.may_complete?
  end

  def destroy?
    current_user.try(:admin?)
  end

  def edit?
    owner_or_admin?
  end

  def index?
    true
  end

  def new?
    create?
  end

  def show?
    entry.present?
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:city, :description, :postal_code, :street_name, :street_number, :title, :user_id]
  end

  private

  def owner_or_admin?
    entry.user == current_user || current_user.try(:admin?)
  end
end
